# frozen_string_literal: true

module Shimmer
  module Form
    class Field
      class_attribute :type

      attr_reader :builder, :method, :collection, :id_method, :name_method, :options

      class << self
        def can_handle?(method)
          false
        end
      end

      def wrapper_options
        {}
      end

      def initialize(builder:, method:, collection:, id_method:, name_method:, options: {})
        @builder = builder
        @method = method
        @collection = collection
        @id_method = id_method
        @name_method = name_method
        @options = options
      end
    end
  end
end
