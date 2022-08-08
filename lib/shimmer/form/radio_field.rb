module Shimmer
  module Form
    class RadioField < Field
      self.type = :radio

      def render
        builder.collection_radio_buttons method, collection, id_method, name_method, {}, options
      end
    end
  end
end
