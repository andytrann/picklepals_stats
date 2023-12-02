class CreatePlayers < ActiveRecord::Migration[6.1]
  def change
    create_table :players do |t|
      t.string :name
      t.string :email
      t.boolean :admin
      t.boolean :active
      t.string :password_digest
      t.string :remember_digest
      t.string :reset_digest
      t.datetime :reset_sent_at

      t.timestamps
    end
    add_index :players, :email, unique: true
    add_index :players, :name
  end
end
