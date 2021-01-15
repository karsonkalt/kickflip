class CreateParksTable < ActiveRecord::Migration[6.1]
  def change
    add_table :parks do |t|
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

      :name, :difficulty, :geolocation, :vert_park, :stree_park, :skate_spot, :skateboard_permitted, :scooter_permitted, :bike_permitted, :open_time, :close_time

    end
  end
end
