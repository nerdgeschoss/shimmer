# frozen_string_literal: true

module Shimmer
  module Auth
    class AppleProvider < Provider
      self.token_column = :apple_id

      private

      def request_details(params)
        name = params[:user] ? JSON.parse(params[:user])["name"] : {}
        headers = {
          'Content-Type': "application/x-www-form-urlencoded"
        }
        form = {
          grant_type: "authorization_code",
          code: params[:code],
          client_id: Config.instance.apple_bundle_id!,
          client_secret: Config.instance.apple_client_secret,
          scope: "name email"
        }
        response = HTTParty.post("https://appleid.apple.com/auth/token", body: URI.encode_www_form(form), headers: headers)
        raise InvalidTokenError, "Login check failed: #{response.body}" unless response.ok?

        token = JWT.decode(response["id_token"], nil, false).first
        UserDetails.new token: token["sub"], email: token["email"], first_name: name["firstName"], last_name: name["lastName"]
      end
    end
  end
end
