# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'schema' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:order_items) }
  end

  it 'has a valid factory' do
    expect(FactoryBot.build(:product)).to be_valid
  end

  it 'is valid with a name' do
    expect(create(:product)).to be_valid
  end

  it 'is invalid without an name' do
    product = FactoryBot.build(:product, name: nil)
    product.valid?
    expect(product.errors[:name]).to include(I18n.t('test.errors.blank'))
  end
end
