# frozen_string_literal: true

class TicketConfirmation
  def self.call(ticket, payment_token, reservation)
    reservation.with_lock do
      tickets_total_price = reservation.tickets_count * ticket.price
      Payment::Gateway.charge(amount: tickets_total_price, token: payment_token)
      reservation.update!(
        status: :booked,
        tickets_total_price: tickets_total_price
      )
    end
  end
end
