# frozen_string_literal: true

require "./lib/exceptions"

class ApiController < ApplicationController
  rescue_from Exceptions::UnprocessableEntityError, Exceptions::InvalidToken, Exceptions::MissingToken,
              with: :unprocessable_entity_error
  rescue_from Exceptions::UnauthorizedAccessError, with: :unauthorized_error
  rescue_from TicketPayment::NotEnoughTicketsError, with: :conflict_error
  rescue_from Payment::Gateway::CardError, Payment::Gateway::PaymentError,
              with: :payment_failed_error

  def current_user
    @current_user ||= User.find(jwt_payload[:user_id])
  end

  private

  def ensure_authenticated
    fail Exceptions::MissingToken, "authorization token not found" unless bearer_token

    jwt_payload[:exp] >= Time.now.to_i && User.find(jwt_payload[:user_id])
  rescue ActiveRecord::RecordNotFound
    raise Exceptions::InvalidToken, "invalid token"
  end

  def jwt_payload
    JsonWebToken.decode(bearer_token)
  end

  def bearer_token
    request.headers.fetch("Authorization", "").split(" ")&.last
  end

  def unprocessable_entity_error(error)
    render json: { error: error.message }, status: :unprocessable_entity
  end

  def unauthorized_error(error)
    render json: { error: error.message }, status: :unauthorized
  end

  def conflict_error(error)
    render json: { error: error.message }, status: :conflict
  end

  def not_found_error(error)
    render json: { error: error.message }, status: :not_found
  end

  def payment_failed_error(error)
    render json: { error: error.message }, status: :payment_required
  end
end
