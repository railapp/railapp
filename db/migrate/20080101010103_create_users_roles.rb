class CreateUsersRoles < ActiveRecord::Migration

  TABLE = 'users_roles'

  def self.up

    create_table TABLE, :force => true do |t|
      t.timestamps
      t.userstamps
      t.column :user_id,  :string
      t.column :role_id,  :string
    end

    add_index TABLE, :user_id
    add_index TABLE, :role_id

  end

  def self.down
    drop_table TABLE
  end

end


class CreateRolesPermissions < ActiveRecord::Migration

  TABLE = 'roles_permissions'

  def self.up

    create_table TABLE, :force => true do |t|
      t.timestamps
      t.userstamps
      t.column :role_id,  :string
      t.column :permission_id,  :string
    end

    add_index TABLE, :role_id
    add_index TABLE, :permission_id

  end

  def self.down
    drop_table TABLE
  end

end


class CreatePermissions < ActiveRecord::Migration

  TABLE = 'permissions'

  def self.up

    create_table TABLE, :force => true do |t|
      t.timestamps
      t.userstamps
      t.column :name,  :string
    end

  end

  def self.down
    drop_table TABLE
  end

end