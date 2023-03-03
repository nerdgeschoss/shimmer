# frozen_string_literal: true

require "rails_helper"

RSpec.describe Shimmer::Config do
  let(:config) { described_class.instance }

  describe "reading a boolean with the '?' methods" do
    it "reads '0' as false" do
      ENV["TEST"] = "0"
      expect(config.test?).to eq false
    end

    it "reads '1' as true" do
      ENV["TEST"] = "1"
      expect(config.test?).to eq true
    end

    it "reads '2' as true" do
      ENV["TEST"] = "2"
      expect(config.test?).to eq true
    end

    it "reads 'TRUE' as true" do
      ENV["TEST"] = "TRUE"
      expect(config.test?).to eq true
    end

    it "reads 'FALSE' as false" do
      ENV["TEST"] = "FALSE"
      expect(config.test?).to eq false
    end
  end

  describe "reading numbers (as strings)" do
    it "reads integer" do
      ENV["TEST"] = "42"
      expect(config.test).to eq "42"
    end

    it "reads decimals (as string)" do
      ENV["TEST"] = "123.456"
      expect(config.test).to eq "123.456"
    end
  end

  describe "reading strings" do
    it "reads empty string as nil" do
      ENV["TEST"] = ""
      expect(config.test).to be_nil
    end

    it "reads string as string" do
      ENV["TEST"] = "Foo bar"
      expect(config.test).to eq "Foo bar"
    end
  end

  describe "support default values" do
    it "for 'true'" do
      expect(config.something_that_does_not_exist?(default: true)).to eq true
    end

    it "for 'false'" do
      expect(config.something_that_does_not_exist?(default: false)).to eq false
    end

    it "for boolean, providing 'something' as a string" do
      expect(config.something_that_does_not_exist?(default: "asd")).to eq true
    end

    it "for strings" do
      expect(config.something_that_does_not_exist(default: "asd")).to eq "asd"
    end
  end
end
