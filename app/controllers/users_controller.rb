# frozen_string_literal: true

class UsersController < ApiController
  def signup
    user = User.new(user_params)

    if user.save
      render json: { email: user.email }
    else
      raise Exceptions::UnprocessableEntityError, user.errors.full_messages.to_sentence
    end
  end

  def login
    email = user_params[:email]
    password = user_params[:password]

    raise Exceptions::UnprocessableEntityError, "email can not be blank" unless email.present?
    raise Exceptions::UnprocessableEntityError, "password can not be blank" unless password.present?

    user = User.find_by(email: email)
    raise Exceptions::AuthenticationError, "can not be authenticated" unless user&.authenticate(password)

    render json: { email: user.email, token: JsonWebToken.encode(user_id: user.id) }
  end

  private

  def user_params
    params.permit(:email, :password)
  end
end
