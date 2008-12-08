class CreateUsers < ActiveRecord::Migration

  def self.up

    create_table "users", :force => true do |t|
      t.timestamps
      t.userstamps
      t.column :first_name,  :string
      t.column :middle_name, :string
      t.column :last_name,   :string
      t.column :nickname,    :string
      t.column :username,    :string
      t.column :password,    :string
    end
      
    add_index :users, :first_name
    add_index :users, :middle_name
    add_index :users, :last_name
    add_index :users, :nickname
    add_index :users, :username

  end

  def self.down
    drop_table "users"
  end

end

