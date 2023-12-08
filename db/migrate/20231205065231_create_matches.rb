class CreateMatches < ActiveRecord::Migration[6.1]
  def change
    create_table :matches do |t|
      t.integer :winning_team_id
      t.integer :losing_team_id
      t.integer :winning_team_score
      t.integer :losing_team_score
      t.datetime :played_at

      t.timestamps
    end
    add_index :matches, [:winning_team_id, :played_at]
    add_index :matches, [:losing_team_id, :played_at]
    add_foreign_key :matches, :teams, column: :winning_team_id
    add_foreign_key :matches, :teams, column: :losing_team_id
  end
end
