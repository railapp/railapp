class CreateCities < ActiveRecord::Migration

  def self.up

    create_table "cities", :force => true do |t|
      t.timestamps
      t.userstamps
      t.column :name,          :string, :null => false
      t.column :latitude,      :float
      t.column :longitude,     :float
      t.column :province_id,   :string, :limit => 6
      t.column :country_id,    :string, :null => false, :limit => 2
      t.column :airport_code,  :string, :limit => 3
      t.column :population,    :integer
      t.column :area,          :integer
    end

    add_index :cities, :name
    add_index :cities, :latitude
    add_index :cities, :longitude
    add_index :cities, :province_id
    add_index :cities, :country_id
    add_index :cities, :airport_code
    add_index :cities, :population
    add_index :cities, :area

  end

  def self.down
    drop_table "cities"
  end

end

