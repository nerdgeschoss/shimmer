# frozen_string_literal: true

module Shimmer
  class SitemapsController < ActionController::Base
    def show
      path = "sitemaps/#{params.require(:path)}.gz"
      filename = "sitemap_#{params[:path]}.xml.gz"

      send_data ActiveStorage::Blob.service.download(path), filename: filename, type: "application/gzip", disposition: "attachment"
    end
  end
end
