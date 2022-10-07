# frozen_string_literal: true

module Shimmer
  module Form
    class CheckboxField < Field
      self.type = :checkbox

      def render
        builder.check_box method, options
      end
    end
  end
end
