# frozen_string_literal: true

module Shimmer
  class FileProxy
    attr_reader :blob_id

    delegate :message_verifier, to: :class
    delegate :content_type, :filename, to: :variant

    class << self
      def restore(id)
        blob_id, resize = message_verifier.verified(id)
        width, height = parse_resize(resize)

        new(blob_id: blob_id, width: width, height: height)
      end

      def parse_resize(resize)
        return if resize.blank?
        return resize if resize.is_a?(Array)

        # In the past, we generated the IDs with ImageMagick style "200x200>" strings. We don't do that anymore, but to prevent all old URLs breaking and caches invalidating at once, we grandfather these URLs in.
        matches = resize.match(/(?<width>\d*)x(?<height>\d*)/)

        [
          matches[:width].presence&.to_i,
          matches[:height].presence&.to_i
        ]
      end

      def message_verifier
        @message_verifier ||= ApplicationRecord.signed_id_verifier
      end
    end

    def initialize(blob_id:, width: nil, height: nil)
      @blob_id = blob_id
      @resize = [width&.to_i, height&.to_i] if width || height
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

    def variant
      @variant ||= if blob.representable?
        options = {resize_to_limit: @resize, format: "webp"}
        blob.representation(options.compact).processed
      else
        blob
      end
    end

    def file
      @file ||= blob.service.download(variant.key)
    end

    private

    def id
      @id ||= message_verifier.generate([blob_id, @resize])
    end
  end
end
