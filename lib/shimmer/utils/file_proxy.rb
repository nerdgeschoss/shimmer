# frozen_string_literal: true

module Shimmer
  class FileProxy
    attr_reader :blob_id

    delegate :message_verifier, to: :class
    delegate :content_type, :filename, to: :blob

    class << self
      def restore(id)
        blob_id, resize = message_verifier.verified(id)
        width, height = resize_string_to_tuple(resize)
        new blob_id: blob_id, width: width, height: height
      end

      def resize_tuple_to_string(resize)
        "#{resize[0]}x#{resize[1]}"
      end

      def resize_string_to_tuple(resize)
        return if resize.blank?

        matches = resize.match(/(?<width>\d*)x(?<height>\d*)/)

        [
          matches[:width].presence&.to_i,
          matches[:height].presence&.to_i
        ]
      end
    end

    def initialize(blob_id:, width: nil, height: nil)
      @blob_id = blob_id
      @resize = [width, height] if width || height
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

    def resizeable?
      @resize.present? && blob.content_type.exclude?("svg")
    end

    def variant
      @variant ||= resizeable? ? blob.representation(resize_to_limit: @resize).processed : blob
    end

    def file
      @file ||= blob.service.download(variant.key)
    end

    private

    def id
      @id ||= message_verifier.generate([blob_id, self.class.resize_tuple_to_string(@resize)])
    end
  end
end
