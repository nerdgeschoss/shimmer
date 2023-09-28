# frozen_string_literal: true

module Shimmer
  class FileProxy
    attr_reader :blob_id, :resize, :quality

    delegate :message_verifier, to: :class
    delegate :content_type, :filename, to: :blob

    class << self
      def restore(id)
        blob_id, resize, quality = message_verifier.verified(id)
        new blob_id: blob_id, resize: resize, quality: quality
      end
    end

    def initialize(blob_id:, resize: nil, width: nil, height: nil, quality: nil)
      @blob_id = blob_id
      @quality = quality

      if !resize && width
        resize = if height
          [width, height]
        else
          [width, nil]
        end
      end
      @resize = resize
    end

    class << self
      def message_verifier
        @message_verifier ||= ApplicationRecord.signed_id_verifier
      end
    end

    def path
      Rails.application.routes.url_helpers.file_path(id, locale: nil)
    end

    def url(protocol: Rails.env.production? ? :https : :http)
      Rails.application.routes.url_helpers.file_url(id, locale: nil, protocol: protocol)
    end

    def blob
      @blob ||= ActiveStorage::Blob.find(blob_id)
    end

    def resizeable
      resize.present? && blob.content_type.exclude?("svg")
    end

    def variant
      transformation_options = {resize_to_limit: resize, format: :webp}
      transformation_options[:quality] = quality if quality

      @variant ||= resizeable ? blob.representation(transformation_options).processed : blob
    end

    def variant_content_type
      resizeable ? "image/webp" : content_type
    end

    def variant_filename
      resizeable ? "#{filename.base}.webp" : filename.to_s
    end

    def file
      @file ||= blob.service.download(variant.key)
    end

    private

    def id
      @id ||= message_verifier.generate([blob_id, resize, quality])
    end
  end
end
