class Role < ActiveRecord::Base
  has_many :users, :through => :users_roles
  has_many :permissions, :through => :roles_permissions
end
