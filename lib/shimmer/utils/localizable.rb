module Shimmer
  module Localizable
    extend ActiveSupport::Concern

    included do
      before_action :set_locale

      def default_url_options(options = {})
        options = {locale: I18n.locale}.merge options
        options[:debug] = true if I18n.debug?
        options
      end

      def request_locale
        request.env["HTTP_ACCEPT_LANGUAGE"].to_s[0..1].downcase.presence&.then { |e| e if I18n.available_locales.include?(e.to_sym) }
      end

      def set_locale
        I18n.locale = url_locale || request_locale || I18n.default_locale
        I18n.debug = params.key?(:debug)
      end

      def check_locale
        redirect_to url_for(locale: I18n.locale) if params[:locale].blank? && request.get? && request.format.html?
      end

      def url_locale
        params[:locale]
      end

      I18n.class_eval do
        next if defined? debug

        thread_mattr_accessor :debug

        class << self
          alias_method :old_translate, :translate
          def translate(key, options = {})
            untranslated_scopes = ["number", "transliterate", "date", "datetime", "errors", "helpers", "support", "time", "faker"].map { |k| "#{k}." }
            key = key.to_s.downcase
            untranslated = untranslated_scopes.any? { |e| key.include? e }
            key_name = [options[:scope], key].flatten.compact.join(".")
            option_names = options.except(:count, :default, :raise, :scope).map { |k, v| "#{k}=#{v}" }.join(", ")
            return "#{key_name} #{option_names}" if I18n.debug && !untranslated

            old_translate(key, **options)
          end
          alias_method :t, :translate

          def debug?
            debug
          end
        end
      end
    end
  end
end
