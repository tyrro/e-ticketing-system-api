# frozen_string_literal: true

class TicketsController < ApiController
  before_action :ensure_authenticated, except: :index
  before_action :set_event
  before_action :set_tickets

  def index
    render :index
  end

  def reserve
    tickets_count = params[:tickets_count].to_i
    return wrong_number_of_tickets("Number of tickets must be greater than zero.") unless tickets_count.positive?
    return wrong_number_of_tickets("Number of tickets must be even.") unless tickets_count.even?
    raise Exceptions::UnprocessableEntityError, "user has active reservation" if current_user.has_active_reservation?(@event)

    TicketReservation.call(current_user, @tickets, tickets_count)
    render json: { success: "Reservation succeeded." }
  end

  def buy
    payment_token = params[:token]
    raise Exceptions::UnprocessableEntityError, "user has no active reservation" unless current_user.has_active_reservation?(@event)

    TicketConfirmation.call(@tickets, payment_token, current_user.active_reservation(@event))
    render json: { success: "Payment succeeded." }
  end

  private

  def ticket_params
    params.permit(:event_id, :token, :tickets_count)
  end

  def set_event
    @event = Event.find(params[:event_id])
  rescue ActiveRecord::RecordNotFound => error
    not_found_error(error)
  end

  def set_tickets
    @tickets = @event.ticket
    if @tickets.present?
      @tickets
    else
      render json: { error: "Ticket not found." }, status: :not_found
    end
  end

  def wrong_number_of_tickets(message)
    render json: { error: message }, status: :unprocessable_entity
  end
end
