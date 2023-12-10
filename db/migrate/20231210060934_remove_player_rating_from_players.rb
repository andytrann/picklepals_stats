class RemovePlayerRatingFromPlayers < ActiveRecord::Migration[6.1]
  def change
    remove_reference :players, :player_rating, null: true, foreign_key: true
  end
end
