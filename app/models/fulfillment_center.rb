class FulfillmentCenter < ApplicationRecord
  # associations
  has_many :orders, as: :fulfiller, dependent: :destroy

  # validations
  validates :name, presence: true
end
