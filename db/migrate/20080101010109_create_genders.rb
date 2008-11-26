class CreatGenders < ActiveRecord::Migration

  def self.up

    create_table "genders", :id => false, :force => true do |t|
      t.column :id,         :string, :null => false, :limit => 1
      t.column :name,       :string, :null => false
    end

    execute("ALTER TABLE languages ADD PRIMARY KEY (id)")

    add_index :genders, :name

  end

  def self.down
    drop_table "gender"
  end

end

