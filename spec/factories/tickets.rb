# frozen_string_literal: true

FactoryBot.define do
  factory :ticket do
    event
    available { Faker::Number.number(digits: 2) }
    price { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
  end
end
