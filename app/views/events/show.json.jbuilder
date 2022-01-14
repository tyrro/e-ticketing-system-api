# frozen_string_literal: true

json.event do
  json.extract! @event, :id, :name, :formatted_time
end
