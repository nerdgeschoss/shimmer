module Shimmer
  class SitemapJob < ActiveJob::Base
    def perform
      SitemapGenerator::Interpreter.run
      SitemapGenerator::Sitemap.ping_search_engines
    end
  end
end
