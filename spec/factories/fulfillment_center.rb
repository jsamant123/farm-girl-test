# frozen_string_literal: true

FactoryBot.define do
  factory :fulfillment_center do
    name { Faker::Name.name }
  end
end
