class CreateTeamMatches < ActiveRecord::Migration[6.1]
  def change
    create_table :team_matches do |t|
      t.references :team,  null: false, foreign_key: true
      t.references :match, null: false, foreign_key: true

      t.timestamps
    end
  end
end
