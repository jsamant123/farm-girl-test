class Order < ApplicationRecord
  # associations
  has_many :order_items, dependent: :destroy
  belongs_to :fulfiller, polymorphic: true

  enum status: %i[not_fulfilled fulfilled]
  accepts_nested_attributes_for :order_items, reject_if: :all_blank, allow_destroy: true

  # scopes
  scope :in_between_dates, ->(start_date, end_date) { where(created_at: start_date..end_date) }

  # validations
  before_validation :set_fulfiller, on: :create
  validate :uniqueness_of_order_items, on: :create

  def product_names
    order_items.map { |item| item.product.name }.join(', ')
  end

  def set_fulfiller
    self.fulfiller = fetch_fulfiller
  end

  def uniqueness_of_order_items
    if order_items.length != order_items.map(&:product_id).uniq.length
      errors.add(:base, I18n.t('order.create.duplicate_order_item'))
    end
  end

  private

  def fetch_fulfiller
    product_ids = order_items.map(&:product_id)
    distribution_center_products = DistributionCenterProduct.with_product_ids(product_ids)
    fulfillers = distribution_center_products.group_by(&:distribution_center_id)
    fulfillers.each do |distribution_center_id, distribution_center_product|
      next unless distribution_center_product.length == product_ids.length
      return DistributionCenter.find(distribution_center_id)
    end
    FulfillmentCenter.first
  end
end
