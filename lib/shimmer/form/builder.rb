# frozen_string_literal: true

module Shimmer
  module Form
    class Builder < ActionView::Helpers::FormBuilder
      class << self
        def input_registry
          @input_registry ||= {}
        end

        def register(klass)
          input_registry[klass.type] = klass
        end
      end

      def input(method, as: guess_type(method), **options)
        as ||= guess_type(method)
        options[:class] ||= "input__input"
        collection = options.delete :collection
        collection_based = !collection.nil? || as == :select
        collection ||= guess_collection(method) if collection_based
        name_method ||= guess_name_method(method) if collection_based
        id_method ||= :id if collection_based
        classes = []
        options[:required] ||= true if options[:required].nil? && required_attributes.include?(method)
        options[:data] ||= {}
        options[:data][:controller] = options.delete(:controller) if options[:controller]
        wrapper_data = {}
        extra = []
        input_class = self.class.input_registry[as]
        raise "Unknown type #{as}" unless input_class
        input = input_class.new(builder: self, method: method, options: options, id_method: id_method, collection: collection, name_method: name_method)
        wrap method: method, content: input.render, classes: classes + ["input--#{as}"], label: options[:label], data: wrapper_data, extra: extra
      end

      private

      def required_attributes
        []
      end

      def guess_type(method)
        self.class.input_registry.values.find { |e| e.can_handle?(method) }&.type || :string
      end

      def guess_collection(method)
        association_for(method)&.klass&.all || enum_for(method).map { |e| OpenStruct.new(id: e, name: e) } || []
      end

      def guess_name_method(method)
        klass = association_for(method)&.klass
        return :name unless klass

        [:display_name, :name, :title].each do |key|
          return key if klass.instance_methods.include?(key)
        end
      end

      def association_for(method)
        collection_method = method.to_s.delete_suffix("_id")
        object.class.reflect_on_association(collection_method) if object.respond_to?(collection_method)
      end

      def enum_for(method)
        object.class.types.keys if object.class.respond_to?(method.to_s.pluralize)
      end

      def wrap(method:, content:, classes:, label:, data: nil, extra: nil)
        if object&.errors&.[](method)&.any?
          classes << "input--error"
          errors = safe_join(object.errors[method].map { |e| content_tag :div, e, class: "input__error" })
        end
        label = label == false ? nil : self.label(method, label, class: "input__label")
        content_tag(:div, safe_join([label, content, errors, extra].compact), class: ["input"] + classes, data: data)
      end

      def helper
        @template
      end

      def value_for(method)
        object.public_send(method)
      end

      delegate :content_tag, :t, :safe_join, :icon, :tag, to: :helper
    end
  end
end
