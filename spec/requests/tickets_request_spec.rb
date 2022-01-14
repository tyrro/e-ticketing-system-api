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

  describe "POST events#buy_ticket" do
    subject { post "/tickets/buy", params: params }

    before { subject }

    context "event exists" do
      context "ticket exists" do
        let(:event) { create(:event, :with_ticket) }
        let(:ticket) { event.ticket }

        context "valid params" do
          let(:params) { { event_id: event.id, token: "token", tickets_count: "1" } }

          it "should have correct HTTP status" do
            expect(response).to have_http_status(:ok)
          end

          it "should render success message" do
            expect(response_json).to eq({ success: "Payment succeeded." })
          end
        end

        context "wrong number of tickets" do
          let(:params) { { event_id: event.id, token: "token", tickets_count: "-" } }

          it "should have correct HTTP status" do
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it "should render success message" do
            expect(response_json).to eq({ error: "Number of tickets must be greater than zero." })
          end
        end

        context "card error" do
          let(:params) { { event_id: event.id, token: "card_error", tickets_count: "1" } }

          it "should have correct HTTP status" do
            expect(response).to have_http_status(402)
          end

          it "should render correct error message" do
            expect(response_json).to eq({ error: "Your card has been declined." })
          end
        end

        context "payment error" do
          let(:params) { { event_id: event.id, token: "payment_error", tickets_count: "1" } }

          it "should have correct HTTP status" do
            expect(response).to have_http_status(402)
          end

          it "should render correct error message" do
            expect(response_json).to eq({ error: "Something went wrong with your transaction." })
          end
        end

        context "not enough tickets left" do
          let(:params) { { event_id: event.id, token: "token", tickets_count: ticket.available + 1 } }

          it "should have correct HTTP status" do
            expect(response).to have_http_status(409)
          end

          it "should render correct error message" do
            expect(response_json).to eq({ error: "Not enough tickets left." })
          end
        end
      end

      context "ticket does not exist" do
        let(:event) { create(:event) }
        let(:params) { { event_id: event.id, token: "token", tickets_count: "1" } }

        it "should have correct HTTP status" do
          expect(response).to have_http_status(:not_found)
        end

        it "should render error" do
          expect(response_json).to eq({ error: "Ticket not found." })
        end
      end
    end

    context "event does not exist" do
      let(:params) { { event_id: "incorrect", token: "token", tickets_count: "1" } }

      it_behaves_like "event not found"
    end
  end
end

def response_json
  JSON.parse(response.body).deep_symbolize_keys
end
