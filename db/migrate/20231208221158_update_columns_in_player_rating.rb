class UpdateColumnsInPlayerRating < ActiveRecord::Migration[6.1]
  def change
    rename_column :player_ratings, :rating, :mu
    add_column :player_ratings, :sigma, :float
  end
end
