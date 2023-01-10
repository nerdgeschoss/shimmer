# frozen_string_literal: true

require "rails_helper"

RSpec.describe Shimmer::Config do
  let(:config) { described_class.instance }

  describe "reading a boolean with the '?' methods" do
    it "reads '0' as false" do
      expect(config.shimmer_test_number_zero?).to eq false
    end

    it "reads '1' as true" do
      expect(config.shimmer_test_number_one?).to eq true
    end

    it "reads '2' as true" do
      expect(config.shimmer_test_number_two?).to eq true
    end

    it "reads 'TRUE' as true" do
      expect(config.shimmer_test_string_true?).to eq true
    end

    it "reads 'FALSE' as false" do
      expect(config.shimmer_test_string_false?).to eq false
    end
  end

  describe "reading numbers (as strings)" do
    it "reads integer" do
      expect(config.shimmer_test_number).to eq "42"
    end

    it "reads decimals" do
      expect(config.shimmer_test_decimal).to eq "123.456"
    end
  end

  describe "reading strings" do
    it "reads empty string as nil" do
      expect(config.shimmer_test_string_nothing).to be_nil
    end

    it "reads empty quoted string as nil" do
      expect(config.shimmer_test_string_empty).to be_nil
    end

    it "reads string as string" do
      expect(config.shimmer_test_string_content).to eq "Foo bar"
    end
  end
end
