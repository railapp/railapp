require File.dirname(__FILE__) + '/../test_helper'
require 'request_rules'

class RequestRulesTest < Test::Unit::TestCase

  include AssertRequest
    
  def test_methods
    r = RequestRules.new
    # Sneaky way to steal the MethodRules object from RequestRules
    methods = r.method :get
    assert_equal [:get], methods.requirements
    r.method :post
    assert_equal [:get, :post], methods.requirements
    r.method :put, :delete
    assert_equal [:get, :post, :put, :delete], methods.requirements
  end

  def test_protocols
    r = RequestRules.new
    # Sneaky way to steal the MethodRules object from RequestRules
    protocols = r.protocol :http
    assert_equal [:http], protocols.requirements
    r.protocol :https
    assert_equal [:http, :https], protocols.requirements
  end
  
  def test_params
    r = RequestRules.new
    assert r.params.children.empty?
    assert r.params.parent.nil?
    assert r.params.name.nil?
  end

end
