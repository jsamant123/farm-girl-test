# frozen_string_literal: true

FactoryBot.define do
  factory :distribution_center do
    name { Faker::Name.name }
  end
end
