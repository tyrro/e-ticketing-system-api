# frozen_string_literal: true

class Exceptions
  UnprocessableEntityError = Class.new(StandardError)
  AuthenticationError      = Class.new(StandardError)
  InvalidToken             = Class.new(StandardError)
  MissingToken             = Class.new(StandardError)
  NotEnoughTicketsError    = Class.new(StandardError)
end
