class CreateParksTable < ActiveRecord::Migration[6.1]
  def change
    create_table :parks do |t|
      t.string :name
      t.integer :difficulty_rating
      t.string :geolocation
      t.boolean :vert_park
      t.boolean :street_park
      t.boolean :skate_spot
      t.boolean :skateboard_permitted
      t.boolean :scooter_permitted
      t.boolean :bike_permitted
      t.time :open_time
      t.time :close_time
      t.timestamps
    end
  end
end
