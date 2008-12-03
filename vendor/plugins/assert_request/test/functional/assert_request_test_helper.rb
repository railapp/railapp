# assert_request Rails Plugin
#
# (c) Copyright 2006 by West Arete Computing, Inc.

# A controller with fake actions that we can call to test their different
# request was deemed to be valid, and redirect if the request was deemed to
# be invalid.
class AssertRequestController < ActionController::Base
  include AssertRequest::PublicMethods

  def get_with_no_params
    assert_request do |r|
      r.method :get
    end
  end  
  
  def one_scalar
    assert_request do |r|
      r.params.must_have :id
    end
  end

  def get_only
    assert_request do |r|
      r.method :get
    end
  end

  def post_only
    assert_request do |r|
      r.method :post
    end
  end

  def put_only
    assert_request do |r|
      r.method :put
    end
  end

  def get_or_post
    assert_request do |r|
      r.method :get, :post
    end
  end

  def may_and_must
    assert_request do |r|
      r.params.must_have :id      
      r.params.may_have :per_page
    end
  end
  
  def double_nested
    assert_request do |r|
      r.method :get
      r.params.must_have :id
      r.params.must_have :page do |page|
        page.must_have :author do |author|
          author.must_have :name
        end
      end
    end
  end
        
  def must_have_dog
    assert_request do |r|
      r.method :get
      r.params.must_have :id 
      r.params.must_have(:dog) { |d| d.is_a Dog }
    end
  end
    
  def may_have_dog
    assert_request do |r|
      r.method :get
      r.params.must_have :id 
      r.params.may_have(:dog) { |d| d.is_a Dog }
    end
  end
    
  def must_be_ssl
    assert_request do |r|
      r.method :get
      r.protocol :https
    end
  end
  
  def default_method_is_get
    assert_request do |r|
    end
  end
  
  def params_must_have_id
    assert_params_must_have :id
  end
  
  def params_must_have_id_and_name
    assert_params_must_have :id, :name
  end

  def params_must_have_dog_name
    assert_params_must_have(:dog) { |dog| dog.must_have :name }
  end
  
  def protocol_is_https
    assert_protocol :https
  end
  
  def method_is_put
    assert_method :put
  end
  
end
