module Shimmer
  module Form
    class CheckboxesField < Field
      self.type = :checkboxes

      def render
        builder.collection_check_boxes method, collection, id_method, name_method, {}, options
      end
    end
  end
end
