module Shimmer
  module Form
    class DateField < Field
      self.type = :date

      def render
        builder.date_field method, options
      end
    end
  end
end
