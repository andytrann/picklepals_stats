class CreatePlayerLeagues < ActiveRecord::Migration[6.1]
  def change
    create_enum "role_type", %w[creator proctor participant]
    create_enum "participant_status", %w[pending active inactive]

    create_table :player_leagues do |t|
      t.references :player, null: false, foreign_key: true
      t.references :league, null: false, foreign_key: true
      t.enum :role, as: :role_type
      t.enum :status, as: :participant_status
      t.datetime :invited_at

      t.timestamps
    end
  end
end
