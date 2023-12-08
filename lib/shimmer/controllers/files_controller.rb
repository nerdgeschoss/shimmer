# frozen_string_literal: true

module Shimmer
  class FilesController < ActionController::Base
    def show
      expires_in 1.year, public: true
      request.session_options[:skip] = true # prevents a session cookie from being set (would prevent caching on CDNs)
      proxy = FileProxy.restore(params.require(:id))
      send_data proxy.file,
        filename: proxy.filename.to_s,
        type: proxy.content_type,
        disposition: "inline"
    rescue ActiveRecord::RecordNotFound, ActiveStorage::FileNotFoundError
      head :not_found
    end
  end
end
