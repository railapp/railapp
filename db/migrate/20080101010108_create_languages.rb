# Language primary key is the Sun Java localization code

class CreateLanguages < ActiveRecord::Migration

  TABLE = 'languages'

  def self.up

    create_table TABLE, :id => false, :force => true do |t|
      t.column :id,         :string, :null => false, :limit => 2
      t.timestamps
      t.userstamps
      t.column :name,       :string, :null => false
    end

    execute("ALTER TABLE #{TABLE} ADD PRIMARY KEY (id)")

    add_index TABLE, :name

  end

  def self.down
    drop_table TABLE
  end

end

