FactoryBot.define do
  factory :order_item do
    order
    menu_snapshot do
      {
        'id' => 1,
        'name' => Faker::Food.dish,
        'price' => 1200,
        'category' => 'メイン'
      }
    end
    quantity { 2 }
    subtotal { 2400 }
  end
end
