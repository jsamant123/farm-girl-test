# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe 'schema' do
    it { is_expected.to have_db_column(:order_id).of_type(:uuid) }
    it { is_expected.to have_db_column(:product_id).of_type(:integer) }
    it { is_expected.to have_db_column(:quantity).of_type(:integer) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:product) }
    it { is_expected.to belong_to(:order) }
  end

  it 'has a valid factory' do
    expect(FactoryBot.build(:order_item)).to be_valid
  end

  it 'is valid with an order, quantity and a product' do
    fulfiller = FactoryBot.create(:fulfillment_center)
    order = FactoryBot.create(:order, fulfiller: fulfiller)
    expect(create(:order_item, order: order)).to be_valid
  end

  it 'is invalid without order details' do
    order_item = FactoryBot.build(:order_item, order_id: nil)
    order_item.valid?
    expect(order_item.errors[:order]).to include(I18n.t('test.errors.must_exist'))
  end

  it 'is invalid without product details' do
    order_item = FactoryBot.build(:order_item, product_id: nil)
    order_item.valid?
    expect(order_item.errors[:product]).to include(I18n.t('test.errors.must_exist'))
  end
end
