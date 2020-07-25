class Product < ApplicationRecord
  # validations
  validates :name, presence: true
end
