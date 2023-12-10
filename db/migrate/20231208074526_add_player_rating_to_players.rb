class AddPlayerRatingToPlayers < ActiveRecord::Migration[6.1]
  def change
    add_reference :players, :player_rating, foreign_key: true
  end
end
