class ChangeTableNumberToNullableInOrders < ActiveRecord::Migration[7.2]
  def change
    change_column_null :orders, :table_number, true
  end
end
