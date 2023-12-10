class CreatePlayerRatings < ActiveRecord::Migration[6.1]
  def change
    create_table :player_ratings do |t|
      t.references :player_match, null: false, foreign_key: true
      t.float :rating
      t.datetime :played_at

      t.timestamps
    end
    add_index :player_ratings, [:player_match_id, :played_at]
  end
end
