# frozen_string_literal: true

class Reservation < ApplicationRecord
  TIME_LIMIT_IN_MINUTES = 15

  belongs_to :event
  belongs_to :user

  enum status: { reserved: 0, booked: 1, timed_out: 2 }
end
