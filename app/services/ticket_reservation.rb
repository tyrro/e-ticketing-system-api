# frozen_string_literal: true

class TicketReservation
  def self.call(user, ticket, tickets_count)
    ticket.with_lock do
      available_tickets = ticket.available
      remaining_tickets = available_tickets - tickets_count
      raise Exceptions::NotEnoughTicketsError, "Not enough tickets left." unless remaining_tickets > 1

      Reservation.create!(
        user: user,
        event: ticket.event,
        tickets_count: tickets_count
      )

      ticket.update(available: remaining_tickets)
    end
  end
end
