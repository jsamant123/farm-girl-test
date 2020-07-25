class Order < ApplicationRecord
  # associations
  has_many :order_items, dependent: :destroy
  belongs_to :fulfiller, polymorphic: true

  enum status: %i[not_fulfilled fulfilled]
end
