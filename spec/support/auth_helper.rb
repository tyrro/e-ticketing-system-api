# frozen_string_literal: true

module AuthHelper
  module Request
    def sign_in_token(user = nil)
      user ||= create(:user)
      JsonWebToken.encode(user_id: user.id)
    end
  end
end
