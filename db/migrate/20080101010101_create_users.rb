class CreateUsers < ActiveRecord::Migration

  TABLE = 'users'

  def self.up

    create_table TABLE, :force => true do |t|

      t.timestamps
      t.userstamps

      ####################################################################
      #
      # NAMES
      # 
      # Customize these as you want.
      #
      # Some ideas are to store a saluation like "Mr." or "Miss",
      # or a suffix like "Junior", or honorific like "Honorable".
      #
      ####################################################################

      t.column :prefix,          :string   # e.g. Mr., Mrs.
      t.column :first_name,      :string
      t.column :middle_name,     :string
      t.column :last_name,       :string
      t.column :suffix,          :string   # e.g. Jr., III,
      t.column :preferred_name,  :string   # i.e. nickname
      t.column :formal_name,     :string
      t.column :sort_name,       :string

      ####################################################################
      #
      # SIGN IN
      # 
      # Customize these as you want.
      #
      # Some ideas are to store a password hint,
      # expiration date, recovery question, etc.
      #
      ####################################################################

      t.column :username,    :string
      t.column :password,    :string


      ####################################################################
      #
      # CHARACTERISTICS
      # 
      # Customize these as you want.
      #
      # Some ideas are to store a person's eye color,
      # shoe size, favorite food, single/married status
      #
      ####################################################################

      t.column :gender,      :string, :length => 1
      t.column :height,      :float
      t.column :weight,      :float
      t.column :born,        :datetime
      t.column :died,        :datetime


      ####################################################################
      #
      # LOCATION
      #
      # This is for tracking where the person is right now.
      # We store these in the user record because we want to
      # be able to do very fast proximity matching for users,
      # for example to find users within 10 miles of a spot.
      #
      ####################################################################

      t.column :latitude,    :float
      t.column :longitude,   :float

    end

    add_index TABLE, :first_name
    add_index TABLE, :middle_name
    add_index TABLE, :last_name
    add_index TABLE, :preferred_name
    add_index TABLE, :username
    add_index TABLE, :gender
    add_index TABLE, :height
    add_index TABLE, :weight
    add_index TABLE, :born
    add_index TABLE, :died
    add_index TABLE, :latitude
    add_index TABLE, :longitude

  end

  def self.down
    drop_table TABLE
  end

end

