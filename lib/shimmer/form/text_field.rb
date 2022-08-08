# frozen_string_literal: true

module Shimmer
  module Form
    class TextField < Field
      self.type = :string

      def render
        builder.text_field method, options
      end
    end
  end
end
