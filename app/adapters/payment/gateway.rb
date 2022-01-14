# frozen_string_literal: true

module Payment
  class Gateway
    CardError = Class.new(StandardError)
    PaymentError = Class.new(StandardError)

    Result = Struct.new(:amount, :currency)

    class << self
      def charge(amount:, token:, currency: "EUR")
        case token.to_sym
        when :card_error
          raise CardError, "Your card has been declined."
        when :payment_error
          raise PaymentError, "Something went wrong with your transaction."
        else
          Result.new(amount, currency)
        end
      end
    end
  end
end
