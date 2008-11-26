class CreateUsersRoles < ActiveRecord::Migration

  def self.up

    create_table "users_roles", :force => true do |t|
      t.timestamps
      t.userstamps
      t.column :user_id,  :string
      t.column :role_id,  :string
    end

    add_index :users_roles, :user_id
    add_index :users_roles, :role_id

  end

  def self.down
    drop_table "users_roles"
  end

end

