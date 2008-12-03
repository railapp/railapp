require File.dirname(__FILE__) + '/../test_helper'
require 'protocol_rules'

class ProtocolRulesTest < Test::Unit::TestCase
  include AssertRequest

  def test_initialize
    assert_equal [], ProtocolRules.new.requirements
    assert_equal [], ProtocolRules.new.allow().requirements
    assert_equal [:http], ProtocolRules.new.allow(:http).requirements
    assert_equal [:http, :https], ProtocolRules.new.allow(:http, :https).requirements
  end

  def test_validate
    rules = ProtocolRules.new
    assert_not_raise(RequestError) { rules.validate('http://') }
    assert_raise(RequestError) { rules.validate('https://') }
    
    rules = ProtocolRules.new.allow(:https)
    assert_not_raise(RequestError) { rules.validate('https://') }
    assert_raise(RequestError) { rules.validate('http://') }
    
    rules = ProtocolRules.new.allow(:http, :https)
    assert_not_raise(RequestError) { rules.validate('http://') }
    assert_not_raise(RequestError) { rules.validate('https://') }
    assert_raise(RequestError) { rules.validate('ftp://') }
  end
  
end