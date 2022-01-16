# frozen_string_literal: true

RSpec.describe "Tickets", type: :request do
  shared_examples "event not found" do
    it "should have correct HTTP status" do
      expect(response).to have_http_status(:not_found)
    end

    it "should render error" do
      expect(response_json).to eq({ error: "Couldn't find Event with 'id'=incorrect" })
    end
  end

  describe "GET tickets#index" do
    context "event exists" do
      subject { get "/tickets", params: params }

      let(:params) { { event_id: event.id } }

      before { subject }

      context "ticket exists" do
        let(:event) { create(:event, :with_ticket) }
        let(:ticket) { event.ticket }

        it "should have correct HTTP status" do
          expect(response).to have_http_status(:ok)
        end

        it "should have correct size" do
          expect(response_json.size).to eq(1)
        end

        it "should render event" do
          expect(response_json).to include(
            tickets: hash_including(
              available: ticket.available,
              price: ticket.price.to_s,
              event: hash_including(
                id: event.id,
                name: event.name,
                formatted_time: event.formatted_time
              )
            )
          )
        end
      end

      context "ticket does not exist" do
        let(:event) { create(:event) }

        it "should have correct HTTP status" do
          expect(response).to have_http_status(:not_found)
        end

        it "should render error" do
          expect(response_json).to eq({ error: "Ticket not found." })
        end
      end
    end

    context "event does not exist" do
      let(:params) { { event_id: "incorrect" } }

      before { get "/tickets", params: params }

      it_behaves_like "event not found"
    end
  end

  describe "POST tickets#reserve" do
    let(:headers) { { 'Authorization': "Bearer #{token}" } }
    let(:token) { sign_in_token }
    subject { post "/tickets/reserve", params: params, headers: headers }

    before { subject }

    context "event exists" do
      context "ticket exists" do
        let(:event) { create(:event, :with_ticket) }
        let(:ticket) { event.ticket }

        context "odd number of tickets" do
          let(:params) { { event_id: event.id, tickets_count: "1" } }

          it "should have correct HTTP status" do
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it "should render failure message" do
            expect(response_json).to eq({ error: "Number of tickets must be even." })
          end
        end

        context "wrong number of tickets" do
          let(:params) { { event_id: event.id, tickets_count: "-" } }

          it "should have correct HTTP status" do
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it "should render success message" do
            expect(response_json).to eq({ error: "Number of tickets must be greater than zero." })
          end
        end

        context "when there is no active reservation" do
          let(:params) { { event_id: event.id, tickets_count: "2" } }

          it "successfully reserves new tickets" do
            expect(response_json).to eq({ success: "Reservation succeeded." })
          end
        end
      end

      context "ticket does not exist" do
        let(:event) { create(:event) }
        let(:params) { { event_id: event.id, tickets_count: "1" } }

        it "should have correct HTTP status" do
          expect(response).to have_http_status(:not_found)
        end

        it "should render error" do
          expect(response_json).to eq({ error: "Ticket not found." })
        end
      end
    end

    context "event does not exist" do
      let(:params) { { event_id: "incorrect", tickets_count: "1" } }

      it_behaves_like "event not found"
    end
  end

  describe "POST tickets#buy" do
    let(:headers) { { 'Authorization': "Bearer #{token}" } }
    let(:token) { sign_in_token(user) }
    let(:user) { create(:user) }
    let!(:reservation) { create(:reservation, user: user, event: event, created_at: Time.now.utc - 2.minutes) }
    let(:event) { create(:event, :with_ticket) }
    let(:ticket) { event.ticket }
    subject { post "/tickets/buy", params: params, headers: headers }

    context "when there is an active reservation" do
      let(:params) { { event_id: event.id, token: "token" } }

      it "successfully books the tickets" do
        subject
        expect(response_json).to eq({ success: "Payment succeeded." })
      end

      it "successfully confirms the tickets" do
        expect(TicketConfirmation).to receive(:call).with(ticket, params[:token], reservation)
        subject
      end
    end

    context "card error" do
      before { subject }
      let(:params) { { event_id: event.id, token: "card_error" } }

      it "should have correct HTTP status" do
        expect(response).to have_http_status(:payment_required)
      end

      it "should render correct error message" do
        expect(response_json).to eq({ error: "Your card has been declined." })
      end
    end

    context "payment error" do
      before { subject }
      let(:params) { { event_id: event.id, token: "payment_error" } }

      it "should have correct HTTP status" do
        expect(response).to have_http_status(:payment_required)
      end

      it "should render correct error message" do
        expect(response_json).to eq({ error: "Something went wrong with your transaction." })
      end
    end
  end
end

def response_json
  JSON.parse(response.body).deep_symbolize_keys
end
