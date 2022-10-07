# frozen_string_literal: true

module Shimmer
  module Form
    class RadiosField < Field
      self.type = :radios

      def render
        builder.collection_radio_buttons method, collection, id_method, name_method, {}, options
      end
    end
  end
end
