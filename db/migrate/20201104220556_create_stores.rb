class CreateStores < ActiveRecord::Migration[6.0]
  def change
    create_table :stores do |t|
      t.string :name
      t.string :country
      t.string :stripe_account_id

      t.timestamps
    end
    add_index :stores, :stripe_account_id, unique: true
  end
end
