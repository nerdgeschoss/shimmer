# frozen_string_literal: true

module Shimmer
  class SitemapsController < ActionController::Base
    def show
      path = request.path[1..]
      filename = path.gsub("/", "-")

      send_data ActiveStorage::Blob.service.download(path), filename: filename, type: "application/gzip", disposition: "attachment"
    end
  end
end
