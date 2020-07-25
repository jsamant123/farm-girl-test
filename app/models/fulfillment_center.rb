class FulfillmentCenter < ApplicationRecord
  # validations
  validates :name, presence: true
end
