class RemoveColumnsFromParks < ActiveRecord::Migration[5.1]
  def change
    remove_column :parks, :difficulty_rating
    remove_column :parks, :vert_park
    remove_column :parks, :street_park
    remove_column :parks, :skate_spot
  end
end
