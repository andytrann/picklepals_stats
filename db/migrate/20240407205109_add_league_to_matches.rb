class AddLeagueToMatches < ActiveRecord::Migration[6.1]
  def change
    add_reference :matches, :league, type: :integer, foreign_key: true
  end
end
