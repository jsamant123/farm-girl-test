# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    status { 'not_fulfilled' }
  end
end
