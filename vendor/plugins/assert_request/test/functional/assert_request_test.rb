# assert_request Rails Plugin
#
# (c) Copyright 2006 by West Arete Computing, Inc.

require File.dirname(__FILE__) + '/../test_helper'
require 'assert_request'
require File.dirname(__FILE__) + '/assert_request_test_helper'

# Re-raise errors caught by the controller.
class AssertRequestController; def rescue_action(e) raise e end; end

class AssertRequestControllerTest < Test::Unit::TestCase
  def setup
    @controller = AssertRequestController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_get_with_no_params
    assert_valid_request :get, :get_with_no_params
    assert_invalid_request :get, :get_with_no_params, {"id" => '3'}
    assert_invalid_request :post, :get_with_no_params
  end

  def test_one_required
    assert_valid_request :get, :one_scalar, {"id" => '3'}
    assert_invalid_request :get, :one_scalar, {"count" => '3'}
    assert_invalid_request :get, :one_scalar
    assert_invalid_request :get, :one_scalar, {"id" => '3', "extra" => '3'}
  end
 
  def test_methods
    assert_valid_request :get, :get_only
    assert_invalid_request :post, :get_only
    assert_invalid_request :put, :get_only
    assert_invalid_request :delete, :get_only
    
    assert_valid_request :post, :post_only
    assert_invalid_request :get, :post_only
    assert_invalid_request :put, :post_only
    assert_invalid_request :delete, :post_only
    
    assert_valid_request :put, :put_only
    assert_invalid_request :post, :put_only
    assert_invalid_request :get, :put_only
    assert_invalid_request :delete, :put_only
    
    assert_valid_request :get, :get_or_post
    assert_valid_request :post, :get_or_post
    assert_invalid_request :put, :get_or_post
    assert_invalid_request :delete, :get_or_post
  end
  
  def test_optional
    assert_valid_request :get, :may_and_must, {"id" => '4', "per_page" => '10'}
    assert_valid_request :get, :may_and_must, {"id" => '4'}
    assert_invalid_request :get, :may_and_must, {"per_page" => '4'}
    assert_invalid_request :get, :may_and_must, {"id" => '4', "per_page" => '10', "extra" => '5'}
    assert_invalid_request :post, :may_and_must, {"id" => '4', "per_page" => '10'}
  end

  def test_double_nested_requirements
    assert_valid_request :get, :double_nested, "id" => '5', "page" => {"author" => {"name" => 'Jack Black'}}
    assert_invalid_request :get, :double_nested, "id" => '5', "page" => {"author" => 'Jack'}
    assert_invalid_request :get, :double_nested, "id" => '5', "page" => {"author" => {"name" => 'Jack Black', "extra" => '5'}}
    assert_invalid_request :get, :double_nested, "id" => '5', "page" => {"author" => {"name" => 'Jack Black'}, "extra" => '5'}    
  end
  
  def test_model
    assert_valid_request :get, :must_have_dog, "id" => '5', "dog" => {"name" => 'luther', "breed" => 'bouvier', "age_in_years" => '12'}
    assert_invalid_request :get, :must_have_dog, "not_the_id" => '5', "dog" => {"name" => 'luther', "breed" => 'bouvier', "age_in_years" => '12'}
    assert_invalid_request :get, :must_have_dog, "id" => '5', "dog" => {"breed" => 'bouvier', "age_in_years" => '12'}
    assert_invalid_request :get, :must_have_dog, "id" => '5', "dog" => {"name" => 'luther', "breed" => 'bouvier', "age_in_years" => '12', "extra" => 'bad'}
    assert_invalid_request :get, :must_have_dog, "id" => '5', "dog" => {}
    assert_invalid_request :get, :must_have_dog, "id" => '5', "dog" => ''
    assert_invalid_request :get, :must_have_dog, "id" => '5', "dog" => nil
  end
  
  def test_optional_model
    assert_valid_request :get, :may_have_dog, "id" => '5', "dog" => {"name" => 'luther', "breed" => 'bouvier', "age_in_years" => '12'}
    assert_valid_request :get, :may_have_dog, "id" => '5'
    assert_invalid_request :get, :may_have_dog, "id" => '5', "dog" => {"breed" => 'bouvier', "age_in_years" => '12'}
    assert_invalid_request :get, :may_have_dog, "id" => '5', "dog" => {}
    assert_invalid_request :get, :may_have_dog, "id" => '5', "dog" => ''
    assert_invalid_request :get, :may_have_dog, "id" => '5', "dog" => nil
    assert_invalid_request :get, :may_have_dog, "id" => '5', "dog" => {"name" => 'luther', "breed" => 'bouvier', "age_in_years" => '12', "extra" => 'bad'}    
  end
  
  def test_protocol
    assert_invalid_request :get, :must_be_ssl    
    # This is how we simulate SSL being on 
    @request.env['HTTPS'] = 'on'
    assert @request.ssl?
    assert_valid_request :get, :must_be_ssl
    @request.env['HTTPS'] = 'off'
  end
  
  def test_get_is_ok_by_default
    assert_valid_request   :get,    :default_method_is_get
    assert_invalid_request :post,   :default_method_is_get
    assert_invalid_request :put,    :default_method_is_get
    assert_invalid_request :delete, :default_method_is_get
  end
  
  def test_method_encoded_in_params_should_be_ignored
    assert_valid_request :get, :one_scalar, "id" => '3'
    assert_valid_request :get, :one_scalar, "id" => '3', "_method" => "put"
    assert_valid_request :get, :one_scalar, "id" => '3', "_method" => "delete"
  end
  
  def test_set_ignore_params
    old_ignore = AssertRequest::ParamRules.ignore_params.dup
    assert_invalid_request :get, :one_scalar, "id" => '3', "undefined" => '4'
    AssertRequest::ParamRules.ignore_params << "undefined"
    assert_valid_request   :get, :one_scalar, "id" => '3', "undefined" => '4'
    assert_invalid_request :get, :one_scalar, "id" => '3', "still_undefined" => '4'
    AssertRequest::ParamRules.ignore_params = old_ignore
  end
  
  def test_params_must_have_id
    # Shouldn't care about anything except the fact that we have "id" at the
    # top level.
    assert_valid_request :get, :params_must_have_id, "id" => '3'
    assert_valid_request :get, :params_must_have_id, "id" => '3', "name" => "bob"
    assert_valid_request :post, :params_must_have_id, "id" => '3', "name" => "bob"
    @request.env['HTTPS'] = 'on'
    assert @request.ssl?
    assert_valid_request :get, :params_must_have_id, "id" => '3'
    @request.env['HTTPS'] = 'off'
    assert_invalid_request :get, :params_must_have_id, "not_id" => '3'
    assert_invalid_request :get, :params_must_have_id, "person" => {"id" => '3'}
    assert_invalid_request :get, :params_must_have_id
  end
  
  def test_params_must_have_id_and_name
    # Shouldn't care about anything except the fact that we have "id" and 
    # "name" at the top level.
    assert_invalid_request :get, :params_must_have_id_and_name, "id" => '3'
    assert_valid_request :get, :params_must_have_id_and_name, "id" => '3', "name" => "bob"
    assert_valid_request :post, :params_must_have_id_and_name, "id" => '3', "name" => "bob", "extra" => "ok"
    @request.env['HTTPS'] = 'on'
    assert @request.ssl?
    assert_valid_request :get, :params_must_have_id_and_name, "id" => '3', "name" => "bob"
    @request.env['HTTPS'] = 'off'
    assert_invalid_request :get, :params_must_have_id_and_name, "not_id" => '3'
    assert_invalid_request :get, :params_must_have_id_and_name, "person" => {"id" => '3'}, "name" => "bob"
    assert_invalid_request :get, :params_must_have_id_and_name
  end
  
  def test_params_must_have_dog_name
    # Shouldn't care about anything except the fact that we have "dog", which
    # contains "name".
    assert_invalid_request :get, :params_must_have_dog_name, "dog" => '3'
    assert_valid_request :get, :params_must_have_dog_name, "dog" => {"name" => "bob"}
    assert_valid_request :post, :params_must_have_dog_name, "dog" => {"name" => "bob"}, "extra" => "ok"
    assert_valid_request :post, :params_must_have_dog_name, "dog" => {"name" => "bob", "extra" => "ok"}
    @request.env['HTTPS'] = 'on'
    assert @request.ssl?
    assert_valid_request :get, :params_must_have_dog_name, "dog" => {"name" => "bob"}
    @request.env['HTTPS'] = 'off'
    assert_invalid_request :get, :params_must_have_dog_name, "not_dog" => {"name" => "bob"}
    assert_invalid_request :get, :params_must_have_dog_name, "dog" => {"not_name" => "bob"}
    assert_invalid_request :get, :params_must_have_dog_name
  end
  
  def test_assert_protocol
    # Shouldn't care about anything except that protocol is https.
    @request.env['HTTPS'] = 'on'
    assert @request.ssl?
    assert_valid_request :get, :protocol_is_https
    assert_valid_request :get, :protocol_is_https, "id" => '3'
    assert_valid_request :put, :protocol_is_https, "id" => '3'
    assert_valid_request :post, :protocol_is_https, "id" => '3', "person" => {"name" => "john"}
    @request.env['HTTPS'] = 'off'
    assert_invalid_request :get, :protocol_is_https
    assert_invalid_request :get, :protocol_is_https, "id" => '3'
    assert_invalid_request :put, :protocol_is_https, "id" => '3'
    assert_invalid_request :post, :protocol_is_https, "id" => '3', "person" => {"name" => "john"}
  end
  
  def test_assert_method
    # Shouldn't care about anything except that the request method is "PUT".
    assert_valid_request :put, :method_is_put
    assert_valid_request :put, :method_is_put, "id" => '3'
    assert_valid_request :put, :method_is_put, "id" => '3', "person" => {"name" => "john"}
    assert_invalid_request :get, :method_is_put
    assert_invalid_request :get, :method_is_put, "id" => '3'
    assert_invalid_request :post, :method_is_put, "id" => '3'
    assert_invalid_request :post, :method_is_put, "id" => '3', "person" => {"name" => "john"}
    @request.env['HTTPS'] = 'on'
    assert @request.ssl?
    assert_invalid_request :get, :method_is_put
    assert_invalid_request :get, :method_is_put, "id" => '3'
    assert_invalid_request :post, :method_is_put, "id" => '3'
    assert_invalid_request :post, :method_is_put, "id" => '3', "person" => {"name" => "john"}
    @request.env['HTTPS'] = 'off'    
  end
  
private

  # Works like "get" or "post", only it also asserts that the request was 
  # successfully validated.
  def assert_valid_request(method, url, *args)
    # We need to dup our args, since assert_response seems to add an extra
    # :only_path key to the hash. This looks like a rails bug.
    if args.first
      args2 = [args.first.dup]
    else
      args2 = args.dup
    end
      
    self.send(method.to_s, url.to_s, *args)
    assert_response :success
  rescue AssertRequest::RequestError => e
    flunk "Received a RequestError exception, but wasn't expecting one: <#{e}>"
  end
  
  # Works like "get" or "post", only it also asserts that we get a failure
  # for the given request.
  def assert_invalid_request(method, url, *args)
    assert_raise(AssertRequest::RequestError) { self.send(method.to_s, url.to_s, *args) }
  end
  
end
