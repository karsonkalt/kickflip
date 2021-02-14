class CreateUserTricks < ActiveRecord::Migration[5.1]
  def change
    create_table :user_tricks do |t|
      t.integer :user_id
      t.integer :trick_id
      t.timestamps
    end
  end
end
