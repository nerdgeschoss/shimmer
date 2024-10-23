# frozen_string_literal: true

module Shimmer
  class Config
    include Singleton

    class MissingConfigError < StandardError; end

    def method_missing(method_name, **options)
      default_provided = options.key?(:default)
      default_value = options.delete(:default) if default_provided
      raise ArgumentError, "unknown option#{"s" if options.length > 1}: #{options.keys.join(", ")}." if options.any?

      credentials = Rails.application.credentials
      method_name = method_name.to_s
      type = :string
      key = method_name.delete_suffix("!").delete_suffix("?").to_sym
      required = method_name.end_with?("!")
      type = :bool if method_name.end_with?("?")
      value = @stubbed_values&.dig(key)
      value ||= ENV[key.to_s.upcase].presence
      value ||= credentials.dig(ENV["CONFIG_ENV"]&.to_sym || Rails.env.to_sym, key)
      value ||= credentials[key]
      value = default_value if value.nil?
      raise MissingConfigError, "#{key.upcase} environment value is missing" if required && value.blank?

      coerce value, type
    end

    def respond_to_missing?(method_name, include_all)
      true
    end

    def stub(**values)
      @stubbed_values = values.to_h.deep_transform_keys(&:to_sym)
      yield
    ensure
      @stubbed_values = nil
    end

    private

    def coerce(value, type)
      return !value.downcase.in?(["n", "0", "no", "false"]) if type == :bool && value.is_a?(String)

      value
    end
  end
end
