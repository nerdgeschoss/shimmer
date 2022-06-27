# frozen_string_literal: true

module Shimmer
  module MetaHelper
    def meta
      @meta ||= Meta.new.tap do |meta|
        meta.canonical = url_for(only_path: false)
      end
    end

    def title(value)
      meta.title = value
    end

    def description(value)
      meta.description = value
    end

    def image(value)
      meta.image = image_file_url(value, width: 1200)
    end

    def render_meta
      tags = meta.tags.map do |tag|
        type = tag.delete(:type) || "meta"
        value = tag.delete(:value)
        content_tag(type, value, tag)
      end
      safe_join tags, "\n"
    end
  end
end
