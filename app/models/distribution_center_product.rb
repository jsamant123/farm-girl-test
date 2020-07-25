class DistributionCenterProduct < ApplicationRecord
  # associations
  belongs_to :distribution_center
  belongs_to :product

  # validations
  validates :product_id, uniqueness: { scope: :distribution_center_id }
end
