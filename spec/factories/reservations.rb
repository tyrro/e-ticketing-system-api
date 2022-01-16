# frozen_string_literal: true

FactoryBot.define do
  factory :reservation do
    event
    user
    status { :reserved }
    tickets_count { Faker::Number.number(digits: 2) }
    tickets_total_price { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
  end
end
