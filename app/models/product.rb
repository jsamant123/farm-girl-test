class Product < ApplicationRecord
  # associations
  has_many :order_items, dependent: :destroy

  # validations
  validates :name, presence: true
end
