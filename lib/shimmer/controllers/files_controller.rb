# frozen_string_literal: true

module Shimmer
  class FilesController < ActionController::Base
    def show
      expires_in 1.year, public: true
      response.headers["Vary"] = "Accept"
      request.session_options[:skip] = true # prevents a session cookie from being set (would prevent caching on CDNs)

      proxy = FileProxy.restore(params.require(:id), format: override_format)
      send_data(
        proxy.file,
        filename: proxy.filename.to_s,
        type: proxy.content_type,
        disposition: "inline"
      )
    rescue ActiveRecord::RecordNotFound, ActiveStorage::FileNotFoundError
      head :not_found
    end

    private

    def override_format
      accepted_formats = request.headers["HTTP_ACCEPT"].to_s

      return "webp" if accepted_formats.include?("image/webp")
      return "webp" if request.path.ends_with?(".webp")

      nil
    end
  end
end
