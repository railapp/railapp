# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'currentuser'

class ApplicationController < ActionController::Base
 
  # include all helpers, all the time
  helper :all

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '0aabb75198658036f4bdb909b9dfa3a6'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password

  include CurrentUser

  #before_filter :authenticate, :authorize

  def redirect_home
    redirect_to '/'
  end

end
