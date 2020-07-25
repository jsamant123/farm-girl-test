# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FulfillmentCenter, type: :model do
  describe 'schema' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
  end

  it 'has a valid factory' do
    expect(FactoryBot.build(:fulfillment_center)).to be_valid
  end

  it 'is valid with a name' do
    expect(create(:fulfillment_center)).to be_valid
  end

  it 'is invalid without an name' do
    fulfillment_center = FactoryBot.build(:fulfillment_center, name: nil)
    fulfillment_center.valid?
    expect(fulfillment_center.errors[:name]).to include(I18n.t('test.errors.blank'))
  end
end
