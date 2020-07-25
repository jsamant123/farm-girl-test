# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DistributionCenter, type: :model do
  describe 'schema' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
  end

  it 'has a valid factory' do
    expect(FactoryBot.build(:distribution_center)).to be_valid
  end

  it 'is valid with a name' do
    expect(create(:distribution_center)).to be_valid
  end

  it 'is invalid without an name' do
    distribution_center = FactoryBot.build(:distribution_center, name: nil)
    distribution_center.valid?
    expect(distribution_center.errors[:name]).to include(I18n.t('test.errors.blank'))
  end
end
