# frozen_string_literal: true

module Shimmer
  class FilesController < ActionController::Base
    def show
      expires_in 1.year, public: true
      request.session_options[:skip] = true # prevents a session cookie from being set (would prevent caching on CDNs)
      proxy = FileProxy.restore(params.require(:id))
      send_data proxy.file,
        filename: proxy.variant_filename,
        type: proxy.variant_content_type,
        disposition: "inline"
    end
  end
end
