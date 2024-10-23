# frozen_string_literal: true

require "rails_helper"

RSpec.describe Shimmer::Config do
  let(:config) { described_class.instance }

  describe "reading a boolean with the '?' methods" do
    it "reads '0' as false" do
      ENV["TEST"] = "0"
      expect(config.test?).to be false
    end

    it "reads '1' as true" do
      ENV["TEST"] = "1"
      expect(config.test?).to be true
    end

    it "reads '2' as true" do
      ENV["TEST"] = "2"
      expect(config.test?).to be true
    end

    it "reads 'TRUE' as true" do
      ENV["TEST"] = "TRUE"
      expect(config.test?).to be true
    end

    it "reads 'FALSE' as false" do
      ENV["TEST"] = "FALSE"
      expect(config.test?).to be false
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

    it "reads a string from rails credentials" do
      Rails.application.credentials[:my_secret_key] = "some-testing-secret"
      expect(config.my_secret_key).to eq "some-testing-secret"
    ensure
      Rails.application.credentials[:my_secret_key] = nil
    end
  end

  describe "supporting environments" do
    it "reads a value prefixed with the current environment" do
      Rails.application.credentials[:test] = {test_key: "test-value"}
      expect(config.test_key).to eq "test-value"
    ensure
      Rails.application.credentials[:test] = nil
    end

    it "allows overriding the environment for configs" do
      ENV["CONFIG_ENV"] = "custom_env"
      Rails.application.credentials[:custom_env] = {test_key: "test-value"}
      expect(config.test_key).to eq "test-value"
    ensure
      ENV["CONFIG_ENV"] = nil
      Rails.application.credentials[:custom_env] = nil
    end
  end

  describe "support default values" do
    it "for 'true'" do
      expect(config.something_that_does_not_exist?(default: true)).to be true
    end

    it "for 'false'" do
      expect(config.something_that_does_not_exist?(default: false)).to be false
    end

    it "for boolean, providing 'something' as a string" do
      expect(config.something_that_does_not_exist?(default: "asd")).to be true
    end

    it "for strings" do
      expect(config.something_that_does_not_exist(default: "asd")).to eq "asd"
    end
  end

  describe "stubbing values" do
    it "allows overriding values" do
      expect(config.some_value).to be_nil
      config.stub(some_value: "stubbed-value") do
        expect(config.some_value).to eq "stubbed-value"
      end
      expect(config.some_value).to be_nil
    end
  end
end
