# frozen_string_literal: true

module Shimmer
  module Form
    class RadioField < Field
      self.type = :radio

      def prepare
        @value = options.delete(:value)
      end

      def render
        builder.radio_button method, @value, options
      end

      def wrapper_options
        {label_method: "#{method}_#{@value.to_s.underscore}".to_sym}
      end
    end
  end
end
