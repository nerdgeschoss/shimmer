module Shimmer
  module Auth
    class Provider
      class InvalidTokenError < StandardError; end
      UserDetails = Struct.new(:token, :email, :first_name, :last_name, keyword_init: true)
      attr_reader :model
      cattr_accessor :token_column

      def initialize(model)
        @model = model
      end

      def login(params:, user_agent: nil, ip: nil)
        user = fetch_user request_details(params)
        create_device user: user, user_agent: user_agent, ip: ip
      end

      def create_device(user:, user_agent: nil, ip: nil)
        user.devices.create!(user_agent: user_agent).tap do |device|
          log_login(user, device_id: device.id, user_agent: user_agent, ip: ip)
        end
      end

      private

      def log_login(user, device_id:, user_agent: nil, ip: nil)
        return unless user.respond_to? :publish

        user.publish :login, provider: self.class.name.demodulize.underscore, device_id: device_id, user_agent: user_agent, ip: ip
      end

      def fetch_user(details)
        user = model.find_by(token_column => details.token) || model.find_by(email: details.email) || model.new
        user[token_column] ||= details.token
        user.email ||= details.email
        user.first_name ||= details.first_name
        user.last_name ||= details.last_name
        user.save! if user.changed?
        user
      end
    end
  end
end

Dir["#{File.expand_path("./auth", __dir__)}/*"].sort.each { |e| require e }
