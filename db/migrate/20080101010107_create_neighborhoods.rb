class CreateNeighborhoods < ActiveRecord::Migration

  TABLE = 'neighborhoods'

  def self.up

    create_table TABLE, :force => true do |t|
      t.timestamps
      t.userstamps
      t.column :name,        :string
      t.column :latitude,    :float
      t.column :longitude,   :float
      t.column :population,  :integer
      t.column :area,        :integer
      t.column :city_id,     :integer
    end

    add_index TABLE, :name
    add_index TABLE, :latitude
    add_index TABLE, :longitude
    add_index TABLE, :population
    add_index TABLE, :area
    add_index TABLE, :city_id

  end

  def self.down
    drop_table TABLE
  end

end

