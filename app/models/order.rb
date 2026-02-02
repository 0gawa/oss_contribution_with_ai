class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy

  enum order_type: {
    dine_in: 0,
    takeout: 1,
    delivery: 2
  }
  
  validates :table_number, length: { maximum: 10 }, allow_nil: true
  validates :total_amount, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :tax_amount, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :status, presence: true, inclusion: { in: %w[pending confirmed completed cancelled] }
  validates :ordered_at, presence: true
  validates :order_type, presence: true, inclusion: { in: order_types.keys }
  
  scope :by_table, ->(table_number) { where(table_number: table_number) }
  scope :by_status, ->(status) { where(status: status) }
  scope :by_order_type, ->(order_type) { where(order_type: order_type) }
  scope :pending, -> { where(status: 'pending') }
  scope :today, -> { where('ordered_at >= ?', Time.current.beginning_of_day) }
end
