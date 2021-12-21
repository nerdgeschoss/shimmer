# frozen_string_literal: true

module Shimmer
  class SitemapsController < ActionController::Base
    def show
      path = "sitemaps/#{params.require(:path)}.gz"
      send_data ActiveStorage::Blob.service.download(path)
    end
  end
end
