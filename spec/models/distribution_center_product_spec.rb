# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DistributionCenterProduct, type: :model do
  describe 'schema' do
    it { is_expected.to have_db_column(:distribution_center_id).of_type(:integer) }
    it { is_expected.to have_db_column(:product_id).of_type(:integer) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:product) }
    it { is_expected.to belong_to(:distribution_center) }
  end

  it 'has a valid factory' do
    expect(FactoryBot.build(:distribution_center_product)).to be_valid
  end

  it 'is valid with a distribution center and a product' do
    expect(create(:distribution_center_product)).to be_valid
  end

  it 'is invalid without distribution center' do
    distribution_center_product = FactoryBot.build(:distribution_center_product, distribution_center_id: nil)
    distribution_center_product.valid?
    expect(distribution_center_product.errors[:distribution_center]).to include(I18n.t('test.errors.must_exist'))
  end

  it 'is invalid without product details' do
    distribution_center_product = FactoryBot.build(:distribution_center_product, product_id: nil)
    distribution_center_product.valid?
    expect(distribution_center_product.errors[:product]).to include(I18n.t('test.errors.must_exist'))
  end

  it 'should not be able to create same record multiple times' do
    distribution_center_product = FactoryBot.create(:distribution_center_product)
    distribution_center_product = FactoryBot.build(:distribution_center_product,
                                                  distribution_center_id: distribution_center_product.distribution_center_id,
                                                  product_id: distribution_center_product.product_id)
    distribution_center_product.valid?
    expect(distribution_center_product.errors[:product_id]).to include(I18n.t('test.errors.taken'))
  end
end
