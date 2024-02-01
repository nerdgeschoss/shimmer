module Shimmer
  class ConsentSettings
    SETTINGS = [:essential, :targeting, :statistic].freeze
    DEFAULT = [:essential].freeze

    SETTINGS.each do |setting|
      attr_accessor setting
      alias_method "#{setting}?", setting
    end

    def initialize(cookies)
      @cookies = cookies
      allowed = @cookies[:consent].to_s.split(",").map(&:strip)
      SETTINGS.each do |setting|
        instance_variable_set "@#{setting}", DEFAULT.include?(setting) || allowed.include?(setting.to_s)
      end
    end

    def save
      value = SETTINGS.map { |e| e.to_s if instance_variable_get("@#{e}") }.compact.join(",")
      @cookies.permanent[:consent] = {value: value, expires: 2.years.from_now}
    end

    def given?
      @cookies[:consent].present?
    end
  end

  module Consent
    extend ActiveSupport::Concern

    included do
      helper_method :consent_settings
      def consent_settings
        @consent_settings ||= ConsentSettings.new(cookies)
      end
    end
  end
end
