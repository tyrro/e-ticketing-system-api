# frozen_string_literal: true

class JsonWebToken
  HMAC_SECRET = Rails.application.secret_key_base

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, HMAC_SECRET)
  end

  def self.decode(token)
    body = JWT.decode(token, HMAC_SECRET).first
    HashWithIndifferentAccess.new body
  rescue JWT::DecodeError => error
    raise Exceptions::InvalidToken, error
  end
end
