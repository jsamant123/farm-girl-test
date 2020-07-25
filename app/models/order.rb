class Order < ApplicationRecord
  # associations
  has_many :order_items, dependent: :destroy
  belongs_to :fulfiller, polymorphic: true

  enum status: %i[not_fulfilled fulfilled]
  accepts_nested_attributes_for :order_items, reject_if: :all_blank, allow_destroy: true

  # scopes
  scope :in_between_dates, ->(start_date, end_date) { where(created_at: start_date..end_date) }
end
