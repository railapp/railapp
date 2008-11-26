class CreateNeighborhoods < ActiveRecord::Migration

  def self.up

    create_table "neighborhoods", :force => true do |t|
      t.timestamps
      t.userstamps
      t.column :name,        :string
      t.column :latitude,    :float
      t.column :longitude,   :float
      t.column :population,  :integer
      t.column :city_id,     :integer
    end

    add_index :neighborhoods, :name
    add_index :neighborhoods, :latitude
    add_index :neighborhoods, :longitude
    add_index :neighborhoods, :population
    add_index :neighborhoods, :city_id

  end

  def self.down
    drop_table "neighborhoods"
  end

end

