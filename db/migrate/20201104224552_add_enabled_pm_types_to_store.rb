class AddEnabledPmTypesToStore < ActiveRecord::Migration[6.0]
  def change
    add_column :stores, :enabled_pm_types, :string, array: true
  end
end
