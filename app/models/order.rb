class Order < ApplicationRecord
  # associations
  belongs_to :fulfiller, polymorphic: true

  enum status: %i[not_fulfilled fulfilled]
end
