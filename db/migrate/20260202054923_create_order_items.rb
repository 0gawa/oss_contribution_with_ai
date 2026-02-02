class CreateOrderItems < ActiveRecord::Migration[7.2]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.json :menu_snapshot, null: false
      t.integer :quantity, null: false
      t.integer :subtotal, null: false

      t.timestamps
    end
  end
end
