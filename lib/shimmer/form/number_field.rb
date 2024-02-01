module Shimmer
  module Form
    class NumberField < Field
      self.type = :number

      def render
        builder.number_field method, options
      end
    end
  end
end
