# frozen_string_literal: true

module Shimmer
  class SitemapAdapter
    def write(location, raw_data)
      SitemapGenerator::FileAdapter.new.write(location, raw_data)
      ActiveStorage::Blob.service.upload("sitemaps/#{location.path_in_public}", File.open(location.path))
    end
  end
end
