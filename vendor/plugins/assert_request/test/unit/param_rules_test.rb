require File.dirname(__FILE__) + '/../test_helper'
require 'param_rules'

class ParamRulesTest < Test::Unit::TestCase

  include AssertRequest
  
  def test_empty
    params = ParamRules.new
    assert_nil params.name
    assert_nil params.parent
    assert params.children.empty?
  end
  
  def test_parent_and_name_must_both_be_nil_or_non_nil
    parent = ParamRules.new
    assert_raise(ArgumentError) { ParamRules.new(nil, parent) }
    assert_raise(ArgumentError) { ParamRules.new("hi", nil)   }
    ParamRules.new("hi", parent)
  end
  
  def test_with_simple_must_have
    add_child(ParamRules.new, true, :id)
  end
  
  def test_simple_may_have
    add_child(ParamRules.new, false, :id)
  end
  
  def test_list_of_names
    params = ParamRules.new
    params.must_have :id, :name, :email
    assert_equal 3, params.children.length
    params.children.each do |child|
      assert_equal params, child.parent
      assert child.children.empty?
    end
    [:id, :name, :email].each do |name|
      assert params.children.detect { |c| c.name == name.to_s }
    end
  end
  
  def test_block_is_not_compatible_with_multiple_names
    assert_raise(ArgumentError) do
      ParamRules.new.must_have :id, :name do |p|
        p.must_have :email
      end
    end
  end
  
  def test_blocks
    root = ParamRules.new
    root.must_have :id
    root.must_have :person do |person|
      person.must_have :name
      person.may_have :age, :height
      person.may_have(:dog) { |d| d.must_have :id }
    end
    assert_equal 2, root.children.length
    assert_equal "id", root.children.first.name
    person = root.children.last
    assert_equal "person", person.name
    assert_equal 4, person.children.length
    assert_equal "name", person.children[0].name
    assert_equal "age", person.children[1].name
    assert_equal "height", person.children[2].name
    assert_equal "dog", person.children[3].name
    dog = person.children[3]
    assert_equal 1, dog.children.length
    assert_equal "id", dog.children.first.name
  end
  
  def test_canonical_name
    root = ParamRules.new
    child1 = add_child(root, true, :id)
    child2 = add_child(root, false, :name)
    grandchild1 = add_child(child1, false, :person)
    grandchild2 = add_child(child1, false, :dog)
    assert_equal "params",               root.canonical_name
    assert_equal "params[:id]",          child1.canonical_name
    assert_equal "params[:name]",        child2.canonical_name
    assert_equal "params[:id][:person]", grandchild1.canonical_name
    assert_equal "params[:id][:dog]",    grandchild2.canonical_name
  end
  
  def test_validate_one_required_param
    root = ParamRules.new
    root.must_have :id
    assert_not_raise(RequestError) { root.validate({"id" => 4}) }
    assert_raise(RequestError) { root.validate({"not_id" => 4}) }
    assert_raise(RequestError) { root.validate({}) }
    assert_raise(RequestError) { root.validate({"id" => 4, "extra" => 5}) }
    assert_raise(RequestError) { root.validate({"id" => {"not expecting nested" => 5}}) }
  end
  
  def test_validate_one_optional_param
    root = ParamRules.new
    root.may_have :id
    assert_not_raise(RequestError) { root.validate({"id" => 4}) }
    assert_not_raise(RequestError) { root.validate({}) }
    assert_raise(RequestError) { root.validate({"not_id" => 4}) }
    assert_raise(RequestError) { root.validate({"id" => 4, "extra" => 5}) }
    assert_raise(RequestError) { root.validate({"id" => {"not expecting nested" => 5}}) }
  end

  def test_validate_multiple_params
    root = ParamRules.new
    root.must_have :id, :name
    assert_not_raise(RequestError) { root.validate({"id" => 4, "name" => "john"}) }
    assert_raise(RequestError) { root.validate({"id" => 4}) }
    assert_raise(RequestError) { root.validate({"name" => "john"}) }
    assert_raise(RequestError) { root.validate({}) }
    assert_raise(RequestError) { root.validate({"id" => 4, "name" => "john", "extra" => "hi"}) }
    assert_raise(RequestError) { root.validate({"id" => {"not expecting nested" => 5}, "name" => "john"}) }
  end
  
  def test_validate_nested_required_params
    root = ParamRules.new
    root.must_have :id
    root.must_have :person do |person|
      person.must_have :name do |name|
        name.must_have :first
      end
      person.must_have :age
    end
    assert_not_raise(RequestError) { root.validate({"id" => 4, "person" => {"name" => {"first" => "john"}, "age" => 12}}) }
    assert_raise(RequestError) { root.validate({"id" => 4, "person" => {"name" => {"first" => "john", "extra" => "hi"}, "age" => 12}}) }
    assert_raise(RequestError)     { root.validate({"id" => 4, "person" => {"name" => {"not_first" => "john"}, "age" => 12}}) }
    assert_raise(RequestError)     { root.validate({"id" => 4, "person" => {"name" => {"first" => "john"}, "not_age" => 12}}) }
    assert_raise(RequestError)     { root.validate({"id" => 4, "person" => {"name" => {"first" => "john"}}}) }
    assert_raise(RequestError)     { root.validate({"id" => 4, "person" => {"name" => "john"}}) }
    assert_raise(RequestError)     { root.validate({"id" => 4, "person" => {"not_name" => {"first" => "john"}, "age" => 12}}) }
  end    
  
  def test_validate_nested_mixed_params
    root = ParamRules.new
    root.must_have :id
    root.must_have :person do |person|
      person.may_have :name do |name|
        name.must_have :first
      end
      person.may_have :age
    end
    # All elements, both required and optional
    assert_not_raise(RequestError) { root.validate({"id" => 4, "person" => {"name" => {"first" => "john"}, "age" => 12}}) }
    # Extra unrecognized element
    assert_raise(RequestError) { root.validate({"id" => 4, "person" => {"name" => {"first" => "john", "extra" => "hi"}, "age" => 12}}) }
    # Don't necessarily need age.
    assert_not_raise(RequestError) { root.validate({"id" => 4, "person" => {"name" => {"first" => "john"}}}) }
    # Don't necessarily need name or age (even though a params value of an empty hash woudn't happen in practice).
    assert_not_raise(RequestError) { root.validate({"id" => 4, "person" => {}}) }
    # But person must be a hash, since it's nested
    assert_raise(RequestError) { root.validate({"id" => 4, "person" => "john"}) }
    # If you have name, you must have first.
    assert_raise(RequestError) { root.validate({"id" => 4, "person" => {"name" => {}}}) }
    assert_raise(RequestError) { root.validate({"id" => 4, "person" => {"name" => "john"}}) }
  end    
  
  def test_should_ignore_certain_common_params
    root = ParamRules.new
    root.must_have :id
    # Make sure they're ignored at the top level
    assert_not_raise(RequestError) { root.validate({"id" => 4}) }
    assert_not_raise(RequestError) { root.validate({"id" => 4, "action" => "show"}) }
    assert_not_raise(RequestError) { root.validate({"id" => 4, "controller" => "person", "action" => "show"}) }
    # Make sure they don't get ignored at a deeper level.
    root.may_have(:person) { |p| p.may_have :name }
    assert_not_raise(RequestError) { root.validate({"id" => 4, "person" => {"name" => "john"}}) }
    assert_raise(RequestError) { root.validate({"id" => 4, "person" => {"name" => "john", "action" => "show"}}) }
  end
  
  def test_is_a_should_only_be_used_with_models
    assert_raise(ArgumentError) { ParamRules.new.must_have(:bob) { |b| b.is_a "string, not an AR class" } }
    assert_raise(ArgumentError) { ParamRules.new.must_have(:bob) { |b| b.is_a Fixnum } }
    assert_not_raise(ArgumentError) { ParamRules.new.must_have(:bob) { |b| b.is_a Dog } }
  end

  def test_must_have_is_a
    root = ParamRules.new
    root.must_have :id
    root.must_have(:dog) { |d| d.is_a Dog }
    assert_not_raise(RequestError) { root.validate({"id" => 4, "dog" => {"name" => "Luther", "breed" => "Bouvier", "age_in_years" => 12}}) }
    assert_raise(RequestError) { root.validate({"id" => 4, "dog" => {"name" => "Luther", "breed" => "Bouvier", "age_in_years" => 12, "extra" => "bad"}}) }
    assert_raise(RequestError) { root.validate({"id" => 4, "dog" => {"name" => "Luther", "breed" => "Bouvier"}}) }
    assert_raise(RequestError) { root.validate({"id" => 4, "dog" => {"name" => "Luther", "breed" => "Bouvier", "age_in_years" => 12}, "extra" => "bad"}) }
    assert_raise(RequestError) { root.validate({"id" => 4}) }
    assert_raise(RequestError) { root.validate({"id" => 4, "dog" => {}}) }
    assert_raise(RequestError) { root.validate({"id" => 4, "dog" => "empty"}) }
  end

  def test_may_have_is_a
    root = ParamRules.new
    root.must_have :id
    root.may_have(:dog) { |d| d.is_a Dog }
    assert_not_raise(RequestError) { root.validate({"id" => 4, "dog" => {"name" => "Luther", "breed" => "Bouvier", "age_in_years" => 12}}) }
    assert_not_raise(RequestError) { root.validate({"id" => 4}) }
    assert_raise(RequestError) { root.validate({"id" => 4, "dog" => {"name" => "Luther", "breed" => "Bouvier", "age_in_years" => 12, "extra" => "bad"}}) }
    assert_raise(RequestError) { root.validate({"id" => 4, "dog" => {"name" => "Luther", "breed" => "Bouvier"}}) }
    assert_raise(RequestError) { root.validate({"id" => 4, "dog" => {"name" => "Luther", "breed" => "Bouvier", "age_in_years" => 12}, "extra" => "bad"}) }
    assert_raise(RequestError) { root.validate({"id" => 4, "dog" => {}}) }
    assert_raise(RequestError) { root.validate({"id" => 4, "dog" => "empty"}) }
  end
  
  def test_validation_should_not_alter_params_hash
    root = ParamRules.new
    root.must_have :id
    root.must_have :person do |person|
      person.may_have :name do |name|
        name.must_have :first
      end
      person.may_have :age
    end
    params = {"id" => 4, "person" => {"name" => {"first" => "john"}, "age" => 12}}
    original_params = params.dup
    root.validate(params)
    assert_equal original_params, params
  end
  
  def test_must_not_have
    root = ParamRules.new
    root.must_have :id
    root.must_have :luther do |luther| 
      luther.is_a Dog 
      luther.must_not_have :age_in_years
    end
    assert_not_raise(RequestError) { root.validate({"id" => 4, "luther" => {"name" => "Luther", "breed" => "Bouvier"}}) }
    assert_raise(RequestError) { root.validate({"id" => 4, "luther" => {"name" => "Luther", "breed" => "Bouvier", "age_in_years" => 12}}) }
    assert_raise(RequestError) { root.validate({"id" => 4, "luther" => {"name" => "Luther", "breed" => "Bouvier", "something_else" => 12}}) }
  end

  def test_must_not_have_multiple
    root = ParamRules.new
    root.must_have :id
    root.must_have :luther do |luther| 
      luther.is_a Dog 
      luther.must_not_have :age_in_years, :breed
    end
    assert_not_raise(RequestError) { root.validate({"id" => 4, "luther" => {"name" => "Luther"}}) }
    assert_raise(RequestError) { root.validate({"id" => 4, "luther" => {"name" => "Luther", "age_in_years" => 12}}) }
    assert_raise(RequestError) { root.validate({"id" => 4, "luther" => {"name" => "Luther", "breed" => "Bouvier"}}) }
    assert_raise(RequestError) { root.validate({"id" => 4, "luther" => {"name" => "Luther", "breed" => "Bouvier", "age_in_years" => 12}}) }
    assert_raise(RequestError) { root.validate({"id" => 4, "luther" => {"name" => "Luther", "breed" => "Bouvier", "something_else" => 12}}) }
  end
  
  def test_ignore_unexpected
    root = ParamRules.new(nil, nil, true, true)
    root.must_have :id
    assert_not_raise(RequestError) { root.validate({"id" => 4}) }
    assert_raise(RequestError) { root.validate({"not_id" => 4}) }
    assert_not_raise(RequestError) { root.validate({"id" => 4, "extra" => "ok"}) }
  end

  def test_ignore_nested_unexpected
    root = ParamRules.new(nil, nil, true, true)
    root.must_have :id
    root.must_have :luther do |luther| 
      luther.is_a Dog 
    end
    assert_not_raise(RequestError) { root.validate({"id" => 4, "luther" => {"name" => "Luther", "breed" => "Bouvier", "age_in_years" => 12}}) }
    assert_raise(RequestError)     { root.validate({"id" => 4, "luther" => {"name" => "Luther", "breed" => "Bouvier", "not_age_in_years" => 12}}) }
    assert_not_raise(RequestError) { root.validate({"id" => 4, "luther" => {"name" => "Luther", "breed" => "Bouvier", "age_in_years" => 12, "extra" => "ok"}}) }
  end
  
  def test_must_have_is_a_shortcut
    root = ParamRules.new
    root.must_have :id, Dog
    assert_not_raise(RequestError) { root.validate({"id" => 4, "dog" => {"name" => "Luther", "breed" => "Bouvier", "age_in_years" => 12}}) }
    assert_raise(RequestError) { root.validate({"id" => 4, "dog" => {"name" => "Luther", "breed" => "Bouvier", "age_in_years" => 12, "extra" => "bad"}}) }
    assert_raise(RequestError) { root.validate({"id" => 4, "dog" => {"name" => "Luther", "breed" => "Bouvier"}}) }
    assert_raise(RequestError) { root.validate({"id" => 4, "dog" => {"name" => "Luther", "breed" => "Bouvier", "age_in_years" => 12}, "extra" => "bad"}) }
    assert_raise(RequestError) { root.validate({"id" => 4}) }
    assert_raise(RequestError) { root.validate({"id" => 4, "dog" => {}}) }
    assert_raise(RequestError) { root.validate({"id" => 4, "dog" => "empty"}) }
  end

  def test_may_have_is_a_shortcut
    root = ParamRules.new
    root.must_have :id
    root.may_have Dog
    assert_not_raise(RequestError) { root.validate({"id" => 4, "dog" => {"name" => "Luther", "breed" => "Bouvier", "age_in_years" => 12}}) }
    assert_not_raise(RequestError) { root.validate({"id" => 4}) }
    assert_raise(RequestError) { root.validate({"id" => 4, "dog" => {"name" => "Luther", "breed" => "Bouvier", "age_in_years" => 12, "extra" => "bad"}}) }
    assert_raise(RequestError) { root.validate({"id" => 4, "dog" => {"name" => "Luther", "breed" => "Bouvier"}}) }
    assert_raise(RequestError) { root.validate({"id" => 4, "dog" => {"name" => "Luther", "breed" => "Bouvier", "age_in_years" => 12}, "extra" => "bad"}) }
    assert_raise(RequestError) { root.validate({"id" => 4, "dog" => {}}) }
    assert_raise(RequestError) { root.validate({"id" => 4, "dog" => "empty"}) }
  end
  
  def test_must_not_have_with_shortcut
    root = ParamRules.new
    root.must_have :id
    root.must_have Dog do |dog| 
      dog.must_not_have :age_in_years
    end
    assert_not_raise(RequestError) { root.validate({"id" => 4, "dog" => {"name" => "Luther", "breed" => "Bouvier"}}) }
    assert_raise(RequestError)     { root.validate({"id" => 4, "dog" => {"name" => "Luther", "breed" => "Bouvier", "age_in_years" => 12}}) }
    assert_raise(RequestError)     { root.validate({"id" => 4, "dog" => {"name" => "Luther", "breed" => "Bouvier", "something_else" => 12}}) }
  end

  

  private
  
  # Add a new child with the given name and required status to the given
  # parent.
  def add_child(parent, required, name)
    old_num_children = parent.children.length
    if required
      parent.must_have name
    else
      parent.may_have name
    end
    assert_equal old_num_children+1, parent.children.length
    # Here we presume that the child got added to the end of the children.
    child = parent.children.last
    assert_equal name.to_s, child.name
    assert_equal parent, child.parent
    assert child.children.empty?
    if required
      assert child.required?    
    else
      assert ! child.required?
    end
    child
  end
end