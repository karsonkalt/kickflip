class CreateTricksTable < ActiveRecord::Migration[5.1]
  def change
    create_table :tricks do |t|
      t.string :name
    end
  end
end
