# frozen_string_literal: true

FactoryBot.define do
  factory :distribution_center_product do
    distribution_center
    product
  end
end
