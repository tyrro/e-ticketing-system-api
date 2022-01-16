
# frozen_string_literal: true

RSpec.describe CheckReservationStatusWorker, type: :worker do
  describe ".call" do
    subject { described_class.new.perform(reservation_id) }
    let(:user) { create(:user) }
    let(:ticket) { create(:ticket) }
    let(:reservation) { create(:reservation, user: user, event: ticket.event) }
    let(:total_tickets_count) { ticket.available + reservation.tickets_count }

    it "matches with enqueued job" do
      expect { described_class.perform_async(reservation.id) }.
        to change(described_class.jobs, :size).by(1)
    end

    context "when reservation is already booked" do
      let(:reservation) { create(:reservation, status: :booked, user: user, event: ticket.event) }
      let(:reservation_id) { reservation.id }

      it "doesn't perform anything" do
        expect { subject }.not_to change { reservation.status }
      end
    end

    context "when reservation is not booked" do
      let(:reservation_id) { reservation.id }

      it "releases the reserved seats" do
        expect { subject }.to change { ticket.reload.available }.from(ticket.available).to(total_tickets_count)
      end

      it "changes reservation status from reserved to timed_out" do
        expect { subject }.to change { reservation.reload.status }.from("reserved").to("timed_out")
      end
    end
  end
end
