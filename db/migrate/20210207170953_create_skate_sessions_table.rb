class CreateSkateSessionsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :skate_sessions do |t|
      t.integer :user_id
      t.integer :park_id
      t.timestamps
    end
  end
end
