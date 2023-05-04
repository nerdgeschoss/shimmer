# frozen_string_literal: true

module Shimmer
  class Config
    include Singleton

    class MissingConfigError < StandardError; end

    def method_missing(method_name, **options)
      return nil if ENV["SECRET_KEY_BASE_DUMMY"]

      default_provided = options.key?(:default)
      default_value = options.delete(:default) if default_provided
      raise ArgumentError, "unknown option#{"s" if options.length > 1}: #{options.keys.join(", ")}." if options.any?

      method_name = method_name.to_s
      type = :string
      key = method_name.delete_suffix("!").delete_suffix("?")
      required = method_name.end_with?("!")
      type = :bool if method_name.end_with?("?")
      value = ENV[key.upcase].presence
      value ||= Rails.application.credentials.public_send(key)
      value = default_value if value.nil?
      raise MissingConfigError, "#{key.upcase} environment value is missing" if required && value.blank?

      coerce value, type
    end

    def respond_to_missing?(method_name)
      true
    end

    private

    def coerce(value, type)
      return !value.downcase.in?(["n", "0", "no", "false"]) if type == :bool && value.is_a?(String)

      value
    end
  end
end
