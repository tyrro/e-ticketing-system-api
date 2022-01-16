# frozen_string_literal: true

RSpec.describe "Users", type: :request do
  describe "POST users#signup" do
    subject { post "/users/signup", params: params }

    context "with valid params" do
      let(:params) { { email: "email", password: "password" } }
      before { subject }

      it "should have correct HTTP status" do
        expect(response).to have_http_status(:ok)
      end

      it "should render all events" do
        expect(response_json).to eq({ email: params[:email] })
      end
    end

    context "with invalid params" do
      let(:params) { { email: "email" } }
      before { subject }

      it "should have correct HTTP status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "should render all events" do
        expect(response_json).to eq({ error: "Password can't be blank and Password digest can't be blank" })
      end
    end
  end

  describe "POST users#login" do
    subject { post "/users/login", params: params }

    context "with valid params" do
      let(:user) { create(:user) }
      let(:email) { user.email }
      let(:password) { user.password }
      let(:params) { { email: email, password: password } }
      before { subject }

      it "should have correct HTTP status" do
        expect(response).to have_http_status(:ok)
      end

      it "should render all events" do
        expect(response_json).to eq(
          {
            email: params[:email],
            token: JsonWebToken.encode(user_id: user.id)
          }
        )
      end
    end

    context "with invalid params" do
      let(:user) { create(:user) }
      let(:email) { user.email }
      let(:params) { { email: email, password: "password" } }
      before { subject }

      it "should have correct HTTP status" do
        expect(response).to have_http_status(:unauthorized)
      end

      it "should render all events" do
        expect(response_json).to eq({ error: "can not be authenticated" })
      end
    end
  end
end

def response_json
  JSON.parse(response.body).deep_symbolize_keys
end
