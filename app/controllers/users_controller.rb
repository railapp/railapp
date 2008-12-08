class UsersController < ApplicationController
  active_scaffold :user
  #resource_controller
  include Signin
end
