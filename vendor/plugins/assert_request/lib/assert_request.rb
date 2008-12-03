# assert_request Rails Plugin
#
# (c) Copyright 2007 by West Arete Computing, Inc.

require 'request_rules'
require 'method_rules'
require 'protocol_rules'
require 'param_rules'
require 'request_error'

module AssertRequest
  
  # This module contains the methods that can be called by your rails 
  # application. It's mixed in to your application controller automatically
  # by this plugin's init.rb file.
  module PublicMethods

    # This is the granddaddy of the assertions for this plugin. Use this 
    # method at the beginning of your action to declare the rules for requests
    # that it receives. If a request doesn't match your declaration, then
    # assert_request will raise a RequestError exception. By default, this
    # gets turned into a 404 Not Found response in production mode.
    #
    # Here is a fairly complex assert_request declaration that illustrates some
    # of its capabilities:
    #
    #   assert_request do |r|
    #     r.method :post, :put
    #     r.protocol :https
    #     r.params.must_have :id
    #     r.params.must_have :person do |person|
    #       person.must_have :name
    #       person.may_have :age, :height
    #     end
    #     r.params.must_have :fido do |fido|
    #       fido.is_a Dog
    #     end
    #     r.params.may_have User do |user|
    #       user.must_not_have :admin, :password
    #     end
    #   end
    #
    # It should be noted that assert_request will also raise a RequestError
    # exception for unexpected params -- ones that aren't declared in your
    # block. If this is too strict for your needs, or if you know some but not
    # all of the params that you're going to encounter (such as in a 
    # before_filter), then assert_params_must_have may be a good alternative.
    #
    # Here some pointers to within the documentation to learn about each part
    # of the example above:
    # 
    # * RequestRules#method for the request method, such
    #   as GET, POST, PUT, DELETE.
    # * RequestRules#protocol for the protocol, such as HTTP or HTTPS
    # * RequestRules#params for an overview of declaring parameters
    #   * ParamRules#must_have for specifying elements that *must* appear in the
    #     params hash.
    #   * ParamRules#may_have for specifying elements that are permitted in the 
    #     params hash, but are not required.
    #   * ParamRules#is_a for a convenient shortcut for declaring params that
    #     match an ActiveRecord model.
    #   * ParamRules#must_not_have for excluding some attributes declared via
    #     ParamRules#is_a.
    # * RequestError for information about the exception that's raised when
    #   a request doesn't match the declaration, and how that exception is 
    #   handled.
    # 
    def assert_request #:yields: request
      safe_assertion do
        rules = RequestRules.new
        yield rules
        rules.validate(request)
      end
    end

    # Checks the params hash for the given elements, but ignores all other 
    # params and other aspects of the request. This allows you to specify a 
    # minimum requirement for the params without having to specify all the 
    # optional elements. This is useful for before_filters, since a filter
    # may use one common parameter, but probably covers several actions, each
    # with different request profiles. Here is an example if its use:
    # 
    #   assert_params_must_have :id, :name
    # 
    # This verifies that the params hash contains an :id element and a :name
    # element, and ignores all other aspects of the request. 
    #
    # To illustrate the difference between assert_params_must_have and 
    # assert_request, here is a similar example of the latter:
    # 
    #   assert_request do |r| 
    #     r.params.must_have :id, :name
    #   end
    # 
    # However, this declaration will complain if there are any elements other 
    # than :id and :name in the params hash, whereas assert_params_must_have 
    # will not. Both methods raise a RequestError if their criteria are not met.
    #   
    # This method can be used exactly the same way as ParamRules#must_have ; it
    # can take multiple arguments, or it can accept a block to describe nested
    # params. See ParamRules#must_have for more detail.
    #
    def assert_params_must_have(*args, &block) #:yeilds: name
      safe_assertion do
        param_rules = ParamRules.new(nil, nil, true, true)
        param_rules.must_have(*args, &block)
        param_rules.validate(params)
      end
    end    
  
    # Checks that the current request protocol matches one of the given 
    # arguments. Ignores all other aspects of the request (in this way it 
    # differs from assert_request). This method behaves 
    # the same way as RequestRules#protocol. See its description for more 
    # detail. 
    def assert_protocol(*args)
      safe_assertion do
        ProtocolRules.new.allow(*args).validate(request.protocol)
      end
    end
  
    # Checks that the current request method matches one of the given 
    # arguments. Ignores all other aspects of the request (in this way it 
    # differs from assert_request). This method behaves 
    # the same way as RequestRules#method. See its description for more 
    # detail. 
    def assert_method(*args)
      safe_assertion do
        MethodRules.new.allow(*args).validate(request.method)
      end
    end

    private

    # Run the given code wrapped in a rescue block, so that we temporarily trap 
    # and log any RequestError exceptions that get raised.
    def safe_assertion
      yield
    rescue RequestError
      logger.error "Bad request: #{$!}" 
      raise        
    end

  end
end
