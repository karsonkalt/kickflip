class RemoveOpenTimeCloseTimeFromParks < ActiveRecord::Migration[5.1]
  def change
      remove_column :parks, :open_time
      remove_column :parks, :close_time
  end
end
