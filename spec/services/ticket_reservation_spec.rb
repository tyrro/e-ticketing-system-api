# frozen_string_literal: true

RSpec.describe TicketReservation do
  describe ".call" do
    subject { described_class.call(user, ticket, tickets_count) }

    let(:user) { create(:user) }
    let(:ticket) { create(:ticket) }

    context "when tickets are available" do
      let(:tickets_count) { 1 }

      it "creates a reservation" do
        expect { subject }.to change { Reservation.count }.from(0).to(1)
      end

      it "updates available tickets count" do
        expect { subject }.to change(ticket, :available).by(-tickets_count)
      end
    end

    context "when tickets are not available" do
      let(:tickets_count) { ticket.available + 1 }

      it "raises error" do
        expect { subject }.to raise_error(Exceptions::NotEnoughTicketsError)
      end
    end

    context "when requested number of tickets leave total tickets to 1" do
      let(:tickets_count) { ticket.available - 1 }

      it "raises error" do
        expect { subject }.to raise_error(Exceptions::NotEnoughTicketsError)
      end
    end
  end
end
