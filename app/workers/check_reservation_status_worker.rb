# frozen_string_literal: true

class CheckReservationStatusWorker
  include Sidekiq::Worker

  def perform(reservation_id)
    reservation = Reservation.find(reservation_id)

    if reservation.booked?
      Rails.logger.info "reservation_id #{reservation_id} already booked, skipping"
    else
      Rails.logger.error "reservation_id #{reservation_id} not booked, releasing reserved tickets"
      ticket = reservation.event.ticket
      ticket.increment!(:available, reservation.tickets_count)
      reservation.timed_out!
    end
  end
end
