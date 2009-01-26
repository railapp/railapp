# Province primary key is the ISO 3166-2 national subdivision code

class CreateProvinces < ActiveRecord::Migration

  TABLE = 'provinces'

  def self.up

    create_table TABLE, :id => false, :force => true do |t|
      t.column :id,         :string, :null => false, :limit => 6
      t.column :country_id, :string, :null => false, :limit => 2
      t.column :code,       :string, :limit => 3
      t.timestamps
      t.userstamps
      t.column :name,       :string, :null => false
      t.column :latitude,   :float
      t.column :longitude,  :float
      t.column :population, :integer
      t.column :area,       :integer
    end

    execute("ALTER TABLE #{TABLE} ADD PRIMARY KEY (id)")

    add_index TABLE, :country_id
    add_index TABLE, :code
    add_index TABLE, :name
    add_index TABLE, :latitude
    add_index TABLE, :longitude
    add_index TABLE, :population
    add_index TABLE, :area

  end

  def self.down
    drop_table TABLE
  end

end

