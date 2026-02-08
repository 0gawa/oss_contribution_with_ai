module Orders
  class OrderBuilder
    def initialize(table_number:, order_type:, items:, menus_cache:, idempotency_key:)
      @table_number = table_number
      @order_type = order_type
      @items = items
      @menus_cache = menus_cache
      @idempotency_key = idempotency_key
    end

    def build
      items_with_menus = build_items_with_menus
      calculator = OrderCalculationService.new(items_with_menus)

      order = Order.new(
        table_number: @table_number,
        order_type: @order_type,
        total_amount: calculator.total_amount,
        tax_amount: calculator.tax_amount,
        status: "pending",
        ordered_at: Time.current,
        idempotency_key: @idempotency_key
      )

      attach_order_items(order, items_with_menus, calculator)
      order
    end

    private

    def build_items_with_menus
      @items.map do |item_data|
        {
          menu: @menus_cache[item_data[:menu_id]],
          quantity: item_data[:quantity]
        }
      end
    end

    def attach_order_items(order, items_with_menus, calculator)
      items_with_menus.each do |item|
        order.order_items.build(
          menu_snapshot: MenuSnapshotSerializer.serialize(item[:menu]),
          quantity: item[:quantity],
          subtotal: calculator.item_subtotal(item[:menu], item[:quantity])
        )
      end
    end
  end
end
