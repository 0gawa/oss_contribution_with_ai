module Orders
  class OrderBuilder
    def initialize(table_number:, order_type:, items_with_menus:, idempotency_key:)
      @table_number = table_number
      @order_type = order_type
      @items_with_menus = items_with_menus
      @idempotency_key = idempotency_key
    end

    def build
      calculator = OrderCalculationService.new(@items_with_menus)

      order = Order.new(
        table_number: @table_number,
        order_type: @order_type,
        total_amount: calculator.total_amount,
        tax_amount: calculator.tax_amount,
        status: "pending",
        ordered_at: Time.current,
        idempotency_key: @idempotency_key
      )

      attach_order_items(order, calculator)
      order
    end

    private

    def attach_order_items(order, calculator)
      @items_with_menus.each do |item|
        order.order_items.build(
          menu_snapshot: MenuSnapshotSerializer.serialize(item[:menu]),
          quantity: item[:quantity],
          subtotal: calculator.item_subtotal(item[:menu], item[:quantity])
        )
      end
    end
  end
end
