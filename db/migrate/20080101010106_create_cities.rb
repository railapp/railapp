class CreateCities < ActiveRecord::Migration

  TABLE = 'cities'

  def self.up

    create_table TABLE, :force => true do |t|
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

    add_index TABLE, :name
    add_index TABLE, :latitude
    add_index TABLE, :longitude
    add_index TABLE, :province_id
    add_index TABLE, :country_id
    add_index TABLE, :airport_code
    add_index TABLE, :population
    add_index TABLE, :area

  end

  def self.down
    drop_table TABLE
  end

end

