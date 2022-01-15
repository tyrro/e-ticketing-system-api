# frozen_string_literal: true

class TicketReservation
  def self.call(user, ticket, tickets_count)
    ticket.with_lock do
      available_tickets = ticket.available
      remaining_tickets = available_tickets - tickets_count
      raise Exceptions::NotEnoughTicketsError, "Not enough tickets left." if remaining_tickets == 1
      raise Exceptions::NotEnoughTicketsError, "Not enough tickets left." if remaining_tickets < 0

      reservation = Reservation.create!(
        user: user,
        event: ticket.event,
        tickets_count: tickets_count
      )

      CheckReservationStatusWorker.perform_in("#{Reservation::TIME_LIMIT_IN_MINUTES}".to_i.minutes, reservation.id)

      ticket.update(available: remaining_tickets)
    end
  end
end
