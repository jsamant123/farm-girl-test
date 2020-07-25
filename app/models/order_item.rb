class OrderItem < ApplicationRecord
  # associations
  belongs_to :order
  belongs_to :product

  # validations
  validates_uniqueness_of :product_id, scope: :order_id
end
