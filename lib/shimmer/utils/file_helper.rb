# frozen_string_literal: true

module Shimmer
  module FileHelper
    def image_tag(source, **options)
      return nil if source.blank?

      if source.is_a?(ActiveStorage::Variant) || source.is_a?(ActiveStorage::Attached) || source.is_a?(ActiveStorage::Attachment) || source.is_a?(ActionText::Attachment)
        attachment = source
        width = options[:width]
        height = options[:height]
        source = image_file_url(source, width: width, height: height)
        options[:loading] = :lazy
        options[:srcset] = "#{source} 1x, #{image_file_url(attachment, width: width.to_i * 2, height: height ? height.to_i * 2 : nil)} 2x" if options[:width].present?
      end
      super source, options
    end

    def image_file_url(source, width: nil, height: nil)
      return if source.blank?
      return source if source.is_a?(String)

      blob = source.try(:blob) || source
      Shimmer::FileProxy.new(blob_id: blob.id, width: width, height: height).url
    end
  end
end
