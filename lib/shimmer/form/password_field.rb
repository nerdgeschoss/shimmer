module Shimmer
  module Form
    class PasswordField < Field
      self.type = :password

      class << self
        def can_handle?(method)
          method.to_s.end_with?("password")
        end
      end

      def render
        builder.password_field method, options
      end
    end
  end
end
