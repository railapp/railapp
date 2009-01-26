require 'bcrypt'
require 'password_attribute'
require 'password_text'

class User < ActiveRecord::Base

  include BCrypt
  include PasswordAttribute

  belongs_to :gender

  has_many :phone_numbers
  has_many :postal_addresses
  has_many :roles, :through => :users_roles
  has_many :email_addresses, :through => :users_emails
  has_many :ethnicities
  has_many :languages
  has_many :abilities

end

