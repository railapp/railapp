class CreateRoles < ActiveRecord::Migration

  TABLE = 'roles'

  def self.up

    create_table TABLE, :force => true do |t|
      t.timestamps
      t.userstamps
      t.column :name,  :string
      t.column :parent_id, :int
    end

    add_index TABLE, :name
    add_index TABLE, :parent_id

  end

  def self.down
    drop_table TABLE
  end

end

