# assert_request Rails Plugin
#
# (c) Copyright 2007 by West Arete Computing, Inc.

require 'request_error'

module AssertRequest
  
  # This class is used to declare the structure of the params hash for this
  # request. It is available via RequestRules#params. 
  class ParamRules
    attr_reader :name, :parent, :children #:nodoc:
    
    # The list of params that we should allow (but not require) by default. It's as if we
    # said that all requests may_have these elements. By default this
    # list is set to:
    #
    # * action
    # * controller
    # * commit
    # * _method
    #
    # You can modify this list in your environment.rb if you need to. Always
    # use strings, not symbols for the elements. Here's an example:
    #
    #   AssertRequest::ParamRules.ignore_params << "orientation"
    #
    cattr_accessor :ignore_params
    @@ignore_params = %w( action controller commit _method )

    # The columns in ActiveRecord models that we should ignore by
    # default when expanding an is_a directive into a series of 
    # must_have directives for each attribute. These are the 
    # attributes that are almost never present in your forms (and hence your params).
    # By default this list is set to:
    #
    # * id
    # * created_at
    # * updated_at
    # * created_on
    # * updated_on
    # * lock_version
    #
    # You can modify this in your environment.rb if you have common attributes
    # that should always be ignored. Here's an example:
    #
    #   AssertRequest::ParamRules.ignore_columns << "deleted_at"
    #
    cattr_accessor :ignore_columns
    @@ignore_columns = %w( id created_at updated_at created_on updated_on lock_version )
    
    # TODO: Convert this to a hash of options.
    def initialize(name=nil, parent=nil, required=true, ignore_unexpected=false) # :nodoc:
      if (name.nil? && !parent.nil?) || (parent.nil? && !name.nil?)
        raise ArgumentError, "parent and name must both be either nil or not nil"
      end
      @parent = parent
      @required = required
      @children = []
      # Whether to raise an exception when we encounter unexpected params 
      # during validation.
      @ignore_unexpected = ignore_unexpected
      if name.nil?
        @name = nil
      elsif is_model?(name)
        klass = name
        @name = klass.to_s.underscore
        is_a klass
      else
        @name = name.to_s
      end
    end
    
    # Use this directive to specify elements that must be present in the params hash. 
    # Elements are represented by symbols or strings, and a list may be specified in 
    # a single declaration:
    #
    #   assert_request do |r|
    #     r.params.must_have :id, :name
    #   end
    #
    # This states that the params hash *must* contain params[:id] and params[:name], 
    # and nothing else. 
    #
    # To specify nested elements, you can specify a block with a single element.
    # The block then defines that element's children:
    #
    #   assert_request do |r|
    #     r.params.must_have :person do |person|
    #       person.must_have :name
    #     end
    #   end
    # 
    # This states that the params hash *must* contain params[:person][:name], and
    # nothing else. You can nest items arbitrarily deeply.
    # 
    def must_have(*args, &block)
      add_child(true, *args, &block)
    end
    
    # Use this directive to specify elements that are allowed (but not required) to be in the
    # params hash. Has the exact same syntax as must_have, above. The two directives can
    # be used interchangably in any params declaration. Example:
    #
    #   assert_request do |r|
    #     r.params.must_have :person do |person|
    #       person.must_have :name
    #       person.may_have :age, :height
    #     end
    #   end
    #
    # This states that the params hash must contain params[:person][:name],
    # but it may or may not contain params[:person][:age] or params[:person][:height].
    #
    def may_have(*args, &block)
      add_child(false, *args, &block)
    end
    
    # Use this directive to specify one or more elements that must *not* appear in the params hash. This 
    # effectively cancels out a previous must_have declaration for the same element.
    # This is usually used to exclude certain model attributes from an is_a declaration.
    # For example, let's say that we have a Dog model that 
    # has the following table definition:
    #
    #   create_table :dogs do |t|
    #     t.column :name,   :string
    #     t.column :breed,  :string
    #     t.column :collar, :boolean
    #     t.column :age,    :integer
    #   end
    #
    # Given this model, let's now consider the following assert_request declaration:
    #
    #   assert_request do |r|
    #     r.params.must_have :luther do |luther|
    #       luther.is_a Dog
    #       luther.must_not_have :collar, :age
    #     end
    #   end
    #   
    # If we disregard the must_not_have statement for a moment, the is_a statement by itself
    # requires the following params:
    #
    # * params[:luther][:name]
    # * params[:luther][:breed]
    # * params[:luther][:collar]
    # * params[:luther][:age]
    #
    # The must_not_have statement then excludes :collar and :age, so that the
    # final set of required params is:
    # 
    # * params[:luther][:name]
    # * params[:luther][:breed]
    # 
    def must_not_have(*args)
      remove_child(*args)
    end
    
    # This is a shortcut for declaring elements that represent ActiveRecord
    # classes. Essentially, it creates a must_have declaration for each
    # attribute of the given model (excluding the ones in the class
    # attribute ignore_columns, which is described at the top of this page).
    #
    # For example, let's presume that you have an ActiveRecord model 
    # called Person that has a table structure like this:
    #
    #   create_table :people do |t|
    #     t.column :name,    :string
    #     t.column :age,     :integer
    #     t.column :address, :text
    #   end
    #
    # A typical form submission for this model might result in a params hash
    # that would be defined by assert_request like this:
    #
    #   assert_request do |r|
    #     r.params.must_have :person do |person|
    #       person.must_have :name, :age, :address
    #     end
    #   end
    #
    # However, is_a allows you to simply specify the name of the class, and
    # the attributes will be expanded for you automatically. So the following
    # declaration is equivalent to the previous one:
    #
    #   assert_request do |r|
    #     r.params.must_have :person do |person|
    #       person.is_a Person
    #     end
    #   end
    #
    # And in the common case where the parameter key is the lowercase name
    # of the model, you can skip the block and is_a statement and just
    # pass the class to must_have or may_have:
    #
    #   assert_request do |r|
    #     r.params.must_have Person
    #   end
    # 
    def is_a(klass)
      unless is_model?(klass)
        raise ArgumentError, "you must supply an ActiveRecord class to the is_a method"
      end
      klass.columns.each do |c|
        must_have c.name unless ignore_column?(c)
      end
    end

    # Is this a required params element? Implies "must_have".
    def required? #:nodoc:
      @required
    end
    
    # Returns the full name of this parameter as it would be accessed in the
    # action. Example output might be "params[:person][:name]". 
    def canonical_name #:nodoc:
      if parent.nil?
        "params"
      else
        parent.canonical_name + "[:#{name}]" 
      end
    end
    
    # Validate the given parameters against our requirements, raising 
    # exceptions for missing or unexpected parameters.
    def validate(params) #:nodoc:
      recognized_keys = validate_children(params)
      unexpected_keys = params.keys - recognized_keys
      if parent.nil?
        # Only ignore the standard params at the top level.
        unexpected_keys -= @@ignore_params
      end
      unless unexpected_keys.empty?
        raise RequestError, "did not expect #{canonical_name}[:#{unexpected_keys.first}]" unless @ignore_unexpected
      end
    end

    private
    
    # Should we ignore this ActiveRecord column? 
    def ignore_column?(column)
      @@ignore_columns.detect { |name| name.to_s == column.name }
    end
    
    # Determine if the given class is an ActiveRecord model.
    def is_model?(klass)
      klass.respond_to?(:ancestors) &&
        klass.ancestors.detect {|a| a == ActiveRecord::Base}
    end
    
    # Create a new child. The first argument is boolean and says whether the
    # child is required (must_have) or not (may_have).
    def add_child(required, *names)
      if block_given? && names.length != 1
        raise ArgumentError, "you must supply exactly one parameter name with a block"
      end
      names.each do |name|
        child = ParamRules.new(name, self, required, @ignore_unexpected)
        yield child if block_given?
        @children << child
      end          
    end
   
    # Remove the given children. 
    def remove_child(*names)
      names.each do |name|
        children.delete_if { |child| child.name == name.to_s }
      end          
    end
   
    # Validate our children against the given params, looking for missing 
    # required elements. Returns a list of the keys that we were able to
    # recognize.
    def validate_children(params)
      recognized_keys = []
      children.each do |child|
        if params.has_key?(child.name)
          recognized_keys << child.name
          validate_child(child, params[child.name])
        elsif child.required?
          raise RequestError, "request did not include #{child.canonical_name}"
        end
      end
      recognized_keys
    end
    
    # Validate this child against its matching value. 
    def validate_child(child, value)
      if child.children.empty?
        if value.is_a?(Hash)
          raise RequestError, (child.canonical_name + " is a hash, but wasn't expecting it")
        end
      else
        if value.is_a?(Hash)
          child.validate(value)
        else
          raise RequestError, "expected #{child.canonical_name} to be a nested hash"
        end
      end      
    end
    
  end
  
end