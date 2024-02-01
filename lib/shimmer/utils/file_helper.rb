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

      if source.is_a?(ActiveStorage::Variant) || source.is_a?(ActiveStorage::Attached) || source.is_a?(ActiveStorage::Attachment) || source.is_a?(ActionText::Attachment)
        attachment = source
        width = options[:width]
        height = options[:height]
        source = image_file_path(source, width: width, height: height)
        options[:loading] ||= :lazy
        options[:srcset] = "#{source} 1x, #{image_file_path(attachment, width: width.to_i * 2, height: height ? height.to_i * 2 : nil)} 2x" if options[:width].present?
      end
      super source, options
    end

    def image_file_path(source, width: nil, height: nil)
      image_file_proxy(source, width: width, height: height, return_type: :path)
    end

    def image_file_url(source, width: nil, height: nil)
      image_file_proxy(source, width: width, height: height, return_type: :url)
    end

    def image_file_proxy(source, width: nil, height: nil, return_type: nil)
      return if source.blank?
      return source if source.is_a?(String)

      blob = source.try(:blob) || source
      proxy = Shimmer::FileProxy.new(blob_id: blob.id, width: width, height: height)
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
