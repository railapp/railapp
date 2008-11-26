# Country primary key is the ISO 3166-2 country code

class CreateCountries < ActiveRecord::Migration

  def self.up

    create_table "countries", :id => false, :force => true do |t|
      t.column :id,         :string, :null => false, :limit => 2
      t.timestamps
      t.userstamps
      t.column :name,       :string, :null => false
      t.column :latitude,   :float
      t.column :longitude,  :float
      t.column :population, :integer
      t.column :area,       :integer
    end

    execute("ALTER TABLE countries ADD PRIMARY KEY (id)")

    add_index :countries, :name
    add_index :countries, :latitude
    add_index :countries, :longitude
    add_index :countries, :population
    add_index :countries, :area

  end

  def self.down
    drop_table "countries"
  end

end

