class AddForeignKeyToTeams < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :teams, :players, column: :player_one_id
    add_foreign_key :teams, :players, column: :player_two_id
  end
end
