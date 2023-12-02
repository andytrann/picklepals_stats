class UpdateDefaultValuesInAdminAndActiveToPlayers < ActiveRecord::Migration[6.1]
  def change
    change_column_default :players, :admin, false
    change_column_default :players, :active, true
  end
end
