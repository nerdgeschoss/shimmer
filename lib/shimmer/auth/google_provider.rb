module Shimmer
  module Auth
    class GoogleProvider < Provider
      self.token_column = :google_id

      private

      def request_details(params)
        payload = GoogleIDToken::Validator.new.check(params[:credential], ENV.fetch("GOOGLE_CLIENT_ID"))
        UserDetails.new token: payload["sub"], email: payload["email"], first_name: payload["given_name"].presence, last_name: payload["family_name"].presence
      end
    end
  end
end
