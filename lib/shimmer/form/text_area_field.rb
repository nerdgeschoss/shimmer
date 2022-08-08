# frozen_string_literal: true

module Shimmer
  module Form
    class TextAreaField < Field
      self.type = :text

      def render
        builder.text_area method, options
      end
    end
  end
end
