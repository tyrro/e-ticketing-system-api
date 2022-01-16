# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    name { Faker::FunnyName.four_word_name }
    time { Faker::Time.forward }

    trait :with_ticket do
      transient do
        available { nil }
        price { nil }
      end

      after(:create) do |event, evaluator|
        ticket_attributes = attributes_for(:ticket)
        ticket_attributes[:available] = evaluator.available if evaluator.available.present?
        ticket_attributes[:price] = evaluator.price if evaluator.price.present?
        event.create_ticket ticket_attributes
      end
    end
  end
end
