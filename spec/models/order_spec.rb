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
end
