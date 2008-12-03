# assert_request Rails Plugin
#
# (c) Copyright 2007 by West Arete Computing, Inc.

require 'request_error'

module AssertRequest
  # Defines how we handle and validate the request protocol.
  class ProtocolRules #:nodoc:
    attr_reader :requirements
    
    def initialize(requirements=[])
      @requirements = []
    end

    # Add the given request methods to the list of permitted methods. Return
    # self to allow method chaining with "new".
    def allow(*methods)
      @requirements = @requirements.concat(methods).flatten      
      self
    end
    
    # Check the given request protocol.Raises an exception if it is invalid.
    def validate(protocol)
      # method.protocol leaves a trailing :// on its results.
      protocol = protocol.sub(/:\/\/$/, '').to_sym
      # If no requirements were specified, presume HTTP.
      requirements = @requirements.empty? ? [:http] : @requirements
      unless requirements.include? protocol
        raise RequestError, "protocol #{protocol} is not permitted"
      end      
    end
    
  end 
end  
