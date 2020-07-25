# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'schema' do
    it { is_expected.to have_db_column(:status).of_type(:integer) }
    it { is_expected.to have_db_column(:fulfiller_id).of_type(:integer) }
    it { is_expected.to have_db_column(:fulfiller_type).of_type(:string) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:order_items) }
    it { is_expected.to belong_to(:fulfiller) }
  end

  it 'has a valid factory' do
    fulfiller = FactoryBot.create(:fulfillment_center)
    expect(FactoryBot.build(:order, fulfiller: fulfiller)).to be_valid
  end

  it 'is valid with an status and fulfillment details' do
    fulfiller = FactoryBot.create(:fulfillment_center)
    expect(create(:order, fulfiller: fulfiller)).to be_valid
  end

  it 'is invalid without fulfiller details' do
    order = FactoryBot.build(:order, fulfiller_id: nil, fulfiller_type: nil)
    order.valid?
    expect(order.errors[:fulfiller]).to include(I18n.t('test.errors.must_exist'))
  end

  it 'is invalid if same order items' do
    fulfiller = FactoryBot.create(:fulfillment_center)
    order = FactoryBot.create(:order, fulfiller: fulfiller)
    product = FactoryBot.create(:product)
    order.order_items.create(product_id: product.id)
    order_item = order.order_items.create(product_id: product.id)
    order_item.valid?
    expect(order_item.errors[:product_id]).to include(I18n.t('test.errors.taken'))
  end

  it 'should set correct fulfiller' do
    distribution_center = FactoryBot.create(:distribution_center)
    fulfillment_center = FactoryBot.create(:fulfillment_center)
    distribution_center_product = FactoryBot.create(:distribution_center_product, distribution_center_id: distribution_center.id)
    order = FactoryBot.build(:order)
    order.order_items << FactoryBot.build(:order_item, product_id: distribution_center_product.product_id)
    expect(order.save).to eq(true)
    order.reload
    expect(order.fulfiller).to eq(distribution_center)

    order = FactoryBot.build(:order)
    order.order_items << FactoryBot.build(:order_item, product_id: distribution_center_product.product_id)
    order.order_items << FactoryBot.build(:order_item)
    expect(order.save).to eq(true)
    order.reload
    expect(order.fulfiller).to eq(fulfillment_center)
  end
end
