# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    name { Faker::FunnyName.four_word_name }
    time { Faker::Time.forward }

    trait :with_ticket do
      after(:create) do |event|
        create(:ticket, event: event)
      end
    end
  end
end
