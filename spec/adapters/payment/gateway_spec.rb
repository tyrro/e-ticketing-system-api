# frozen_string_literal: true

RSpec.describe Payment::Gateway do
  describe ".charge" do
    subject { Payment::Gateway.charge(amount: 1, token: token) }

    context "with valid token" do
      let(:token) { "token" }

      it "should be truthy" do
        expect(subject).to be_truthy
      end
    end

    context "with card_error" do
      let(:token) { "card_error" }

      it "should raise error" do
        expect { subject }.to raise_error(Payment::Gateway::CardError)
      end
    end

    context "with payment_error" do
      let(:token) { "payment_error" }

      it "should raise error" do
        expect { subject }.to raise_error(Payment::Gateway::PaymentError)
      end
    end
  end
end
