# frozen_string_literal: true

module Shimmer
  class Config
    include Singleton
    class MissingConfigError < StandardError; end

    def method_missing(method_name)
      method_name = method_name.to_s
      type = :string
      key = method_name.delete_suffix("!").delete_suffix("?")
      required = method_name.end_with?("!")
      type = :bool if method_name.end_with?("?")
      value = ENV[key.upcase].presence
      value ||= Rails.application.credentials.send(key)
      raise MissingConfigError, "#{key.upcase} environment value is missing" if required && value.blank?

      coerce value, type
    end

    private

    def coerce(value, type)
      return value.in?(["n", "0", "no", "false"]) ? false : true if type == :bool && value.is_a?(String)

      value
    end
  end
end
