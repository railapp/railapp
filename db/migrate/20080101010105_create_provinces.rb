# Province primary key is the ISO 3166-2 national subdivision code

class CreateProvinces < ActiveRecord::Migration

  def self.up

    create_table "provinces", :id => false, :force => true do |t|
      t.column :id,         :string, :null => false, :limit => 6
      t.column :country_id, :string, :null => false, :limit => 2
      t.column :code,       :string, :limit => 3
      t.timestamps
      t.userstamps
      t.column :name,       :string, :null => false
      t.column :latitude,   :float
      t.column :longitude,  :float
      t.column :population, :integer
    end

    execute("ALTER TABLE provinces ADD PRIMARY KEY (id)")

    add_index :provinces, :country_id
    add_index :provinces, :code
    add_index :provinces, :name
    add_index :provinces, :latitude
    add_index :provinces, :longitude
    add_index :provinces, :population

  end

  def self.down
    drop_table "provinces"
  end

end

