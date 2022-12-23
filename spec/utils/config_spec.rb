# frozen_string_literal: true

RSpec.describe Shimmer::Config do
  let(:config) { described_class.instance }

  describe "reading a boolean with the '?' methods" do
    it "reads '0' as false" do
      expect(config.shimmer_test_number_zero?).to eq false
    end

    it "reads '1' as true" do
      expect(config.shimmer_test_number_one?).to eq true
    end
  end
end
