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

      if source.is_a?(ActiveStorage::Variant) || source.is_a?(ActiveStorage::Attached) || source.is_a?(ActiveStorage::Attachment) || source.is_a?(ActionText::Attachment)
        attachment = source
        width = options[:width]
        height = options[:height]
        quality = options[:quality]

        options[:loading] ||= :lazy
        options[:width], options[:height] = calculate_missing_dimensions!(attachment:, width:, height:)

        if options[:loading] == :lazy
          hash_value, primary_color = preview_values(attachment)
          if hash_value.present?
            options.merge!({
              "data-controller": "thumb-hash",
              "data-thumb-hash-preview-hash-value": hash_value
            })
          end
          if primary_color.present?
            options.merge!({
              style: "background-color: ##{primary_color}; background-size: cover;"
            })
          end
        end

        source = image_file_path(source, width:, height:, quality:)

        if options[:width].present?
          width = width.to_i * 2
          height = height ? options[:height].to_i * 2 : nil
          options[:srcset] = "#{source} 1x, #{image_file_path(attachment, width:, height:, quality:)} 2x"
        end
      end
      super source, **options
    end

    private

    def calculate_missing_dimensions!(attachment:, width:, height:)
      return [width, height] if width && height

      original_width = attachment.blob.metadata["width"]&.to_f
      original_height = attachment.blob.metadata["height"]&.to_f

      return [width, height] unless original_width && original_height

      aspect_ratio = original_width / original_height

      if width.nil? && height.nil?
        [original_width.round, original_height.round]
      elsif width.nil?
        [nil, (height.to_i * aspect_ratio).round]
      elsif height.nil?
        [width, (width.to_i / aspect_ratio).round]
      else
        [width, height]
      end
    end

    def preview_values(attachment, quality: nil)
      if attachment.blob.metadata["preview_hash"] && attachment.blob.metadata["primary_color"]
        return [attachment.blob.metadata["preview_hash"], attachment.blob.metadata["primary_color"]]
      end

      CreateImagePreviewJob.perform_later(attachment.id, quality:)
      ["", ""]
    end

    def image_file_path(source, width: nil, height: nil, quality: nil)
      image_file_proxy(source, width:, height:, return_type: :path)
    end

    def image_file_url(source, width: nil, height: nil, quality: nil)
      image_file_proxy(source, width:, height:, return_type: :url)
    end

    def image_file_proxy(source, width: nil, height: nil, return_type: nil, quality: nil)
      return if source.blank?
      return source if source.is_a?(String)

      blob = source.try(:blob) || source
      proxy = Shimmer::FileProxy.new(blob_id: blob.id, width:, height:, quality:)
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
