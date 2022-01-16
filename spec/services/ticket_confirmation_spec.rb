# frozen_string_literal: true

RSpec.describe TicketConfirmation do
  describe ".call" do
    subject { described_class.call(ticket, token, reservation) }

    let(:user) { create(:user) }
    let!(:reservation) { create(:reservation, user: user, event: ticket.event) }
    let(:ticket) { create(:ticket) }
    let(:tickets_total_price) { reservation.tickets_count * ticket.price }
    let(:token) { "token" }

    it "calls payment adapter" do
      expect(Payment::Gateway).to receive(:charge).with(amount: tickets_total_price, token: token)
      subject
    end

    it "updates reservation status from reserved to booked" do
      expect { subject }.to change { reservation.reload.status }.from("reserved").to("booked")
    end
  end
end
