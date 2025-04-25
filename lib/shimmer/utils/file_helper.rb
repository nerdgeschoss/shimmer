# frozen_string_literal: true

module Shimmer
  module FileHelper
    extend ActiveSupport::Concern

    included do
      ActiveSupport.on_load(:action_view) do
        include Shimmer::FileAdditions
      end
    end
  end

  module FileAdditions
    def image_tag(source, **options)
      return nil if source.blank?

      if source.is_a?(ActiveStorage::Variant) ||
          source.is_a?(ActiveStorage::Attached) ||
          source.is_a?(ActiveStorage::Attachment) ||
          (Object.const_defined?("ActionText::Attachment") && source.is_a?(ActionText::Attachment))
        attachment = source
        width = options[:width]
        height = options[:height]
        format = options[:format]
        source = image_file_path(source, width: width, height: height, format: format)
        options[:loading] ||= :lazy
        if options[:width].present?
          source_2x = image_file_path(attachment, width: width.to_i * 2, height: height ? height.to_i * 2 : nil, format: format)
          options[:srcset] = "#{source} 1x, #{source_2x} 2x"
        end
      end

      super(source, options)
    end

    def image_file_path(source, **)
      image_file_proxy(source, **, return_type: :path)
    end

    def image_file_url(source, **)
      image_file_proxy(source, **, return_type: :url)
    end

    def image_file_proxy(source, width: nil, height: nil, format: nil, return_type: nil)
      return if source.blank?
      return source if source.is_a?(String)

      blob = source.try(:blob) || source
      proxy = Shimmer::FileProxy.new(blob_id: blob.id, width: width, height: height, format: format)
      case return_type
      when nil
        proxy
      when :path
        proxy.path
      when :url
        proxy.url
      end
    end
  end
end
