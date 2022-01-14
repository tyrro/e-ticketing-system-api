10.times do
  e = Event.create!(name: Faker::FunnyName.four_word_name, time: Faker::Time.forward)
  Ticket.create!(event: e, available: 5, price: Faker::Number.decimal(l_digits: 2, r_digits: 2))
end
