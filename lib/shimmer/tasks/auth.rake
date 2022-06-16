# frozen_string_literal: true

namespace :auth do
  desc "Generates a Sign in with Apple Token"
  task :apple_token do
    ecdsa_key = OpenSSL::PKey::EC.new IO.read ".apple-key.p8"
    headers = {
      "kid" => Shimmer::Config.instance.apple_key_id!
    }
    claims = {
      "iss" => Shimmer::Config.instance.apple_team_id!,
      "iat" => Time.now.to_i,
      "exp" => 180.days.from_now.to_i,
      "aud" => "https://appleid.apple.com",
      "sub" => Shimmer::Config.instance.apple_bundle_id!
    }
    puts JWT.encode claims, ecdsa_key, "ES256", headers
  end
end
