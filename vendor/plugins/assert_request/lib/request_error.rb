# assert_request Rails Plugin
#
# (c) Copyright 2007 by West Arete Computing, Inc.

module AssertRequest
  
  # This is the parent class for all exceptions raised (intentionlly) by this
  # plugin. 
  class Error < RuntimeError ; end
  
  # This is the exception that we raise when we find an invalid request. By
  # default, the full details of this exception will be displayed to the 
  # browser in development mode. In production mode it will be intercepted, 
  # and a 404 Not Found response will be displayed to the user. 
  #
  # This means that if you are using the exception_notification plugin to get 
  # emails about exceptions while running in production mode, then you 
  # will not get an email when your application encounters bad 
  # requests. This is intentional, since bad requests in production are not 
  # necessarily an indicator of a bug in your program, and your mailbox can 
  # quickly fill up if your visitors are using out-of-date bookmarks, or if 
  # someone links to your site incorrectly.
  #
  # If you would rather have the assertions in this plugin result
  # in status 500 errors, then edit init.rb in the plugin root and comment
  # out the call to alias_method_chain.
  # 
  class RequestError < Error ; end
  
  # This is the exception that we raise when incorrect or ambiguous arguments
  # are passed to a method in this plugin.
  class ArgumentError < Error ; end
  
end
