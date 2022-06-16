# frozen_string_literal: true

module Shimmer
  module Auth
    module Authenticating
      extend ActiveSupport::Concern

      included do
        before_action :authenticate
        helper_method :current_user

        def require_login
          redirect_to login_path unless current_user
        end

        def current_user
          ::Current.user
        end

        def login(device:)
          ::Current.device = device
          cookies.encrypted[:device_token] = {value: device.token, expires: 2.years.from_now}
        end

        def logout
          cookies.delete :device_token
        end

        private

        def authenticate
          ::Current.device = cookies.encrypted[:device_token].presence&.then { |e| ::Device.find_by token: e }
        end
      end
    end
  end
end
