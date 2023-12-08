# frozen_string_literal: true

require "rails_helper"

RSpec.describe ConfigHelper do
  describe "#stub_config" do
    it "stubs a method to return a specified value" do
      stub_config(test_config: "value")

      expect(Config.test_config).to eq "value"
    end

    it "stubs a method to return nil" do
      stub_config(test_config: nil)

      expect(Config.test_config).to be_nil
    end

    it "stubs a method with a ! suffix to raise an error when value is nil" do
      stub_config(test_config: nil)

      expect { Config.test_config! }.to raise_error(Shimmer::Config::MissingConfigError)
    end

    it "does not raise an error for ! method when value is present" do
      stub_config(test_config: "some value")

      expect { Config.test_config! }.not_to raise_error
    end

    it "stubs a method with a ? suffix to return a boolean value" do
      stub_config(test_config: true)

      expect(Config.test_config?).to be true
    end

    it "returns default value when main config value is nil" do
      stub_config(test_config: nil)

      expect(Config.test_config).to be_nil
      expect(Config.test_config(default: "default_value")).to eq "default_value"
    end

    it "correctly coerces string 'yes' to true" do
      stub_config(test_config: "yes")

      expect(Config.test_config?).to be true
    end

    it "correctly coerces string 'no' to false" do
      stub_config(test_config: "no")

      expect(Config.test_config?).to be false
    end

    it "correctly coerces numeric 1 to true" do
      stub_config(test_config: "1")

      expect(Config.test_config?).to be true
    end

    it "correctly coerces numeric 0 to false" do
      stub_config(test_config: "0")

      expect(Config.test_config?).to be false
    end

    it "handles mixed-case boolean strings correctly" do
      stub_config test_config: "TrUe"

      expect(Config.test_config?).to be true
    end
  end
end
