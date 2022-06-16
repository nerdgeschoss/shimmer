# frozen_string_literal: true

module Shimmer
  module Auth
    module Device
      extend ActiveSupport::Concern

      included do
        has_secure_token

        def name
          [browser.platform.name, browser.name].join(" ")
        end

        private

        def browser
          @browser ||= Browser.new user_agent
        end
      end
    end
  end
end
