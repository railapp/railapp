ENV["RAILS_ENV"] = "test"
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'config', 'environment'))
require 'test_help'

class Test::Unit::TestCase
  # The opposite of assert_raise
  def assert_not_raise(exception, &block)
    yield
    assert true
  rescue exception => e
    flunk "Received a #{exception.to_s} exception, but wasn't expecting one: #{e}"
  end
end

# Simple model to use while testing ActiveRecord requirement types.
class Dog < ActiveRecord::Base ; end

# Redefine the "render" method to render nothing, so that we don't have
# to create views for our actions or call "render :nothing => true" at the
# end of each one. We can't do this with a filter, since calling render 
# within a filter causes the action to be skipped.
class ActionController::Base
  def render_with_force_nothing
    render_without_force_nothing :nothing => true
  end    
  alias_method_chain :render, :force_nothing
end