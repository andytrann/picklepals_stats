class CreateTeams < ActiveRecord::Migration[6.1]
  def change
    create_table :teams do |t|
      t.integer :player_one_id
      t.integer :player_two_id

      t.timestamps
    end
    add_index :teams, :player_one_id
    add_index :teams, :player_two_id
    add_index :teams, [:player_one_id, :player_two_id], unique: true
  end
end
