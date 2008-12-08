class User < ActiveRecord::Base

  include BCrypt
  include PasswordAttribute
  include SecurePassword

end

