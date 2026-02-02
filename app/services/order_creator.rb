class OrderCreator
  VALID_ORDER_TYPES = %w[dine_in takeout delivery].freeze

  attr_reader :order, :errors

  def initialize(table_number:, items:, order_type: 'dine_in')
    @table_number = table_number
    @items = items
    @order_type = order_type
    @errors = []
    @menus_cache = {}
  end

  def call
    ActiveRecord::Base.transaction do
      create_order
    end
  rescue ActiveRecord::RecordInvalid => e
    @errors << e.message
    nil
  end

  def success?
    @errors.empty? && @order&.persisted?
  end

  private

  def create_order
    validate_inputs!
    load_and_validate_menus!
    
    calculator = OrderCalculationService.new(items_with_menus)
    
    @order = Order.new(
      table_number: @table_number,
      order_type: @order_type,
      total_amount: calculator.total_amount,
      tax_amount: calculator.tax_amount,
      status: 'pending',
      ordered_at: Time.current
    )
    
    build_order_items(calculator)
    @order.save!
    @order
  end

  def validate_inputs!
    validate_items!
    validate_order_type!
  end

  def validate_items!
    if @items.blank?
      @errors << '注文アイテムが指定されていません'
      raise ActiveRecord::RecordInvalid.new
    end
  end

  def validate_order_type!
    unless VALID_ORDER_TYPES.include?(@order_type)
      @errors << "order_typeは#{VALID_ORDER_TYPES.join(', ')}のいずれかである必要があります"
      raise ActiveRecord::RecordInvalid.new
    end
  end

  def load_and_validate_menus!
    @items.each do |item_data|
      menu_id = item_data[:menu_id]
      
      begin
        menu = Menu.find(menu_id)
        validate_menu_availability!(menu)
        @menus_cache[menu_id] = menu
      rescue ActiveRecord::RecordNotFound
        @errors << "メニューID #{menu_id} が見つかりません"
        raise ActiveRecord::RecordInvalid.new
      end
    end
  end

  def validate_menu_availability!(menu)
    unless menu.is_available
      @errors << "#{menu.name}は現在注文できません"
      raise ActiveRecord::RecordInvalid.new
    end
  end

  def items_with_menus
    @items.map do |item_data|
      {
        menu: @menus_cache[item_data[:menu_id]],
        quantity: item_data[:quantity]
      }
    end
  end

  def build_order_items(calculator)
    items_with_menus.each do |item|
      @order.order_items.build(
        menu_snapshot: create_menu_snapshot(item[:menu]),
        quantity: item[:quantity],
        subtotal: calculator.item_subtotal(item[:menu], item[:quantity])
      )
    end
  end

  def create_menu_snapshot(menu)
    {
      'id' => menu.id,
      'name' => menu.name,
      'price' => menu.price,
      'category' => menu.category
    }
  end
end
