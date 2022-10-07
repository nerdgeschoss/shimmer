# frozen_string_literal: true

module Shimmer
  module Form
    class ImageField < Field
      self.type = :image

      def render
        builder.file_field method, options.reverse_merge(accept: "image/*")
      end
    end
  end
end
