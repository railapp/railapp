class CreateGenders < ActiveRecord::Migration

  TABLE = 'genders'

  def self.up

    create_table TABLE, :id => false, :force => true do |t|
      t.column :id,         :string, :null => false, :limit => 1
      t.column :name,       :string, :null => false
    end

    execute("ALTER TABLE #{TABLE} ADD PRIMARY KEY (id)")

    add_index TABLE, :name

  end

  def self.down
    drop_table TABLE
  end

end

