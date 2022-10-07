# frozen_string_literal: true

module Shimmer
  module Form
    class DatetimeField < Field
      self.type = :datetime

      def render
        builder.datetime_field method, options
      end
    end
  end
end
