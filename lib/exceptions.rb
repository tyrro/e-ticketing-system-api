class Exceptions
  UnprocessableEntityError = Class.new(StandardError)
  UnauthorizedAccessError = Class.new(StandardError)
  InvalidToken = Class.new(StandardError)
  MissingToken = Class.new(StandardError)
end
