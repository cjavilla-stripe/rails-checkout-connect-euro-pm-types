class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :stripe_checkout_session_id
      t.references :store, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
