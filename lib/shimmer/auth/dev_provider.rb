# frozen_string_literal: true

module Shimmer
  module Auth
    class DevProvider < Provider
      def login(email:, user_agent: nil, ip: nil)
        user = model.find_or_create_by!(email: email)
        device = user.devices.create! user_agent: user_agent
        log_login(user, device_id: device.id, user_agent: user_agent, ip: ip)
        device
      end
    end
  end
end
