class OrderCalculationService
  TAX_RATE = 0.10

  def initialize(items_with_menus)
    @items_with_menus = items_with_menus
  end

  def subtotal
    @items_with_menus.sum { |item| item[:menu].price * item[:quantity] }
  end

  def tax_amount
    (subtotal * TAX_RATE).floor
  end

  def total_amount
    subtotal + tax_amount
  end

  def item_subtotal(menu, quantity)
    menu.price * quantity
  end
end
