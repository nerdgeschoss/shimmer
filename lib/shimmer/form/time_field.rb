module Shimmer
  module Form
    class TimeField < Field
      self.type = :time

      def render
        builder.time_field method, options.reverse_merge(value: object.public_send(method))
      end
    end
  end
end
