# assert_request Rails Plugin
#
# (c) Copyright 2007 by West Arete Computing, Inc.

require 'request_error'

module AssertRequest
  # Defines how we handle and validate the request method.
  class MethodRules #:nodoc:
    attr_reader :requirements
    
    def initialize
      @requirements = []
    end
    
    # Add the given request methods to the list of permitted methods. Return
    # self to allow method chaining with "new".
    def allow(*methods)
      @requirements = @requirements.concat(methods).flatten
      self 
    end
    
    # Check the given request method. Raises an exception if it is invalid.
    def validate(method)
      # If no requirements were specified, presume GET.
      requirements = @requirements.empty? ? [:get] : @requirements
      unless requirements.include? method
        raise RequestError, "request method #{method} is not permitted"
      end      
    end
    
  end 
end  
