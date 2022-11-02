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

      def input(method, as: guess_type(method), wrapper_options: {}, description: nil, label_method: nil, id_method: :id, name_method: nil, label: nil, **options)
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
        extra = []
        input_class = self.class.input_registry[as]
        raise "Unknown type #{as}" unless input_class
        input = input_class.new(builder: self, method: method, options: options, id_method: id_method, collection: collection, name_method: name_method)
        input.prepare
        wrapper_options.reverse_merge! input.wrapper_options
        label_method ||= wrapper_options.delete(:label_method)
        wrap method: method, content: input.render, classes: classes + ["input--#{as}"], label: label, extra: extra, description: description, options: wrapper_options, label_method: label_method
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

      def wrap(method:, content:, classes:, label:, data: nil, extra: nil, description: nil, options: {}, label_method: nil)
        if object&.errors&.[](method)&.any?
          classes << "input--error"
          errors = safe_join(object.errors[method].map { |e| content_tag :div, e, class: "input__error" })
        end
        label = label == false ? nil : self.label(label_method || method, label, class: "input__label")
        description = description.presence ? content_tag(:div, description, class: "input__description") : nil
        content_tag(:div, safe_join([label, content, description, errors, extra].compact), class: ["input"] + classes, **options)
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
