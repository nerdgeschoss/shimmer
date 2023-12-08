# frozen_string_literal: true

module ConfigHelper
  def stub_config(**options)
    options.each do |method_name, return_value|
      method_name = method_name.to_s.downcase

      allow(Config).to receive(method_name).with(any_args) do |*args|
        args = args.first || {}
        return_value.nil? ? args[:default] : return_value
      end

      # Use coerce method from Shimmer::Config
      coerced_value = Shimmer::Config.instance.coerce(return_value, :bool)
      allow(Config).to receive(:"#{method_name}?").and_return(coerced_value)

      allow(Config).to receive(:"#{method_name}!").with(any_args) do
        raise Shimmer::Config::MissingConfigError if return_value.nil?

        return_value
      end
    end
  end
end

RSpec.configure do |config|
  config.include ConfigHelper
end
