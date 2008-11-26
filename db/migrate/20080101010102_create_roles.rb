class CreateRoles < ActiveRecord::Migration

  def self.up

    create_table "roles", :force => true do |t|
      t.timestamps
      t.userstamps
      t.column :name,  :string
    end

    add_index :roles, :name

  end

  def self.down
    drop_table "roles"
  end

end

