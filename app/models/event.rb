# frozen_string_literal: true

class Event < ApplicationRecord
  has_one :ticket
  has_many :reservations

  def formatted_time
    time.strftime("%d %B %Y, %H:%M")
  end
end
