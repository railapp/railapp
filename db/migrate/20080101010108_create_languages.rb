# Language primary key is the Sun Java localization code

class CreateLanguages < ActiveRecord::Migration

  def self.up

    create_table "languages", :id => false, :force => true do |t|
      t.column :id,         :string, :null => false, :limit => 2
      t.timestamps
      t.userstamps
      t.column :name,       :string, :null => false
    end

    execute("ALTER TABLE languages ADD PRIMARY KEY (id)")

    add_index :languages, :name

  end

  def self.down
    drop_table "languages"
  end

end

