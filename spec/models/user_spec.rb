# frozen_string_literal: true

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:event) { create(:event) }

  describe "#active_reservation" do
    let!(:reservation_old) { create(:reservation, user: user, event: event, created_at: Time.now.utc - 20.minutes) }
    let!(:reservation_new) { create(:reservation, user: user, event: event, created_at: Time.now.utc - 2.minutes) }

    subject { user.active_reservation(event) }

    it { is_expected.to eq reservation_new }
  end

  describe "#has_active_reservation?" do
    context "when a reservation created within last 15 minutes" do
      let!(:reservation) { create(:reservation, user: user, event: event, created_at: Time.now.utc - 2.minutes) }

      it "returns true" do
        expect(user).to have_active_reservation(event)
      end
    end

    context "when a reservation not created within last 15 minutes" do
      let!(:reservation) { create(:reservation, user: user, event: event, created_at: Time.now.utc - 20.minutes) }

      it "returns false" do
        expect(user).to_not have_active_reservation(event)
      end
    end
  end
end
