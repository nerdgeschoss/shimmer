# frozen_string_literal: true

module Shimmer
  module Form
    class EmailField < Field
      self.type = :email

      class << self
        def can_handle?(method)
          method.to_s.end_with?("email")
        end
      end

      def render
        builder.email_field method, options
      end
    end
  end
end
