# frozen_string_literal: true

module ConfigHelper
  def stub_config(**options)
    options.each do |method_name, return_value|
      method_name = method_name.to_s.downcase

      allow(Config).to receive(method_name).with(any_args) do |*args|
        args = args.first || {}
        return_value.nil? ? args[:default] : return_value
      end

      allow(Config).to receive(:"#{method_name}?").and_return(coerce_to_boolean(return_value))

      allow(Config).to receive(:"#{method_name}!").with(any_args) do
        raise Shimmer::Config::MissingConfigError if return_value.nil?

        return_value
      end
    end
  end

  private

  def coerce_to_boolean(value)
    return false if value.nil? # Handle nil values

    if value.is_a?(String)
      !value.downcase.in?(["n", "0", "no", "false"])
    elsif value == 0
      false
    elsif value == 1
      true
    else
      value
    end
  end
end

RSpec.configure do |config|
  config.include ConfigHelper
end
