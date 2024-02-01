module Shimmer
  class FileProxy
    attr_reader :blob_id, :resize

    delegate :message_verifier, to: :class
    delegate :content_type, :filename, to: :blob

    class << self
      def restore(id)
        blob_id, resize = message_verifier.verified(id)
        new blob_id: blob_id, resize: resize
      end
    end

    def initialize(blob_id:, resize: nil, width: nil, height: nil)
      @blob_id = blob_id
      if !resize && width
        resize = if height
          "#{width}x#{height}>"
        else
          "#{width}x"
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
      @variant ||= resizeable ? blob.representation(resize: resize).processed : blob
    end

    def file
      @file ||= blob.service.download(variant.key)
    end

    private

    def id
      @id ||= message_verifier.generate([blob_id, resize])
    end
  end
end
