module Shimmer
  module Auth
    module Current
      extend ActiveSupport::Concern

      included do
        attribute :device

        delegate :user, to: :device, allow_nil: true
      end
    end
  end
end
