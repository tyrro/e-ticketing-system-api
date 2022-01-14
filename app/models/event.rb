# frozen_string_literal: true

class Event < ApplicationRecord
  has_one :ticket

  def formatted_time
    time.strftime("%d %B %Y, %H:%M")
  end
end
