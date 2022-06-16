module Shimmer
  module Auth
    module User
      extend ActiveSupport::Concern

      included do
        def authenticate!(user_agent: nil, ip: nil)

          Provider.new(self.class).create_device(user: self, user_agent: user_agent, ip: ip)
        end
      end

      class_methods do
        def login!(provider:, **attributes)
          "Shimmer::Auth::#{provider.to_s.classify}Provider".constantize
            .new(self).login(**attributes)
        end
      end
    end
  end
end
