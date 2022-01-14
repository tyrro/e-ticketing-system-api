# frozen_string_literal: true

RSpec.describe Event, type: :model do
  describe "formatted_time" do
    let(:time) { DateTime.new(2020, 12, 31, 12) }
    let(:event) { create(:event, time: time) }

    it "displays correct date and time" do
      expect(event.formatted_time).to eq("31 December 2020, 12:00")
    end
  end
end
