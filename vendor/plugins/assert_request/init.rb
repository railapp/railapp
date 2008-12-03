class ActionController::Base 
  # Ensure that all controllers have direct access to the assertions.
  include AssertRequest::PublicMethods

  # In production mode, trap assert_request's RequestError exceptions, and
  # render a 404 response instead of the default 500. Comment out the 
  # alias_method_chain call below if you don't want this behavior.
  def rescue_action_in_public_with_request_error(exception)
    if exception.kind_of? AssertRequest::RequestError
      respond_to do |type|
        type.html { render :file => "#{RAILS_ROOT}/public/404.html", :status => "404 Not Found" }
        type.all  { render :nothing => true, :status => "404 Not Found" }
      end
    end
  end
  alias_method_chain :rescue_action_in_public, :request_error
  
end