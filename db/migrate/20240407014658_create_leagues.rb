class CreateLeagues < ActiveRecord::Migration[6.1]
  def change
    create_enum "status_type", %w[pending ongoing closed]
    
    create_table :leagues do |t|
      t.string :name
      t.integer :creator_id
      t.datetime :closed_at
      t.enum :status, as: :status_type

      t.timestamps
    end
    
    add_index :leagues, :creator_id
    add_foreign_key :leagues, :players, column: :creator_id
  end
end
