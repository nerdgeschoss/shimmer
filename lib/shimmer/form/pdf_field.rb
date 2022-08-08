# frozen_string_literal: true

module Shimmer
  module Form
    class PdfField < Field
      self.type = :pdf

      class << self
        def can_handle?(method)
          method.to_s.end_with?("pdf")
        end
      end

      def render
        builder.file_field method, options.reverse_merge(accept: "application/pdf")
      end
    end
  end
end
