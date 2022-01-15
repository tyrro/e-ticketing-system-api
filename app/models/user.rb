# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :reservations

  validates_presence_of :email, :password_digest

  def active_reservation(event)
    reservations
    .where(event: event)
    .where(status: :reserved)
    .where(created_at: Time.now.utc - "#{Reservation::TIME_LIMIT_IN_MINUTES}".to_i.minute..Time.now.utc)&.last
  end

  def has_active_reservation?(event)
    active_reservation(event).present?
  end
end
