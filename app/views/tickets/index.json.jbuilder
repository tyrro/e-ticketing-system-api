# frozen_string_literal: true

json.tickets do
  json.extract! @tickets, :available, :price
  json.event do
    json.extract! @event, :id, :name, :formatted_time
  end
end
