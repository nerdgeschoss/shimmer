module Shimmer
  module Form
    class SelectField < Field
      self.type = :select

      class << self
        def can_handle?(method)
          method.to_s.end_with?("_id")
        end
      end

      def render
        builder.collection_select method, collection, id_method, name_method, {}, options
      end
    end
  end
end
