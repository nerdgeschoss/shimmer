# frozen_string_literal: true

RSpec.configure do |config|
  config.filter_run_when_matching :focus
  config.disable_monkey_patching!
  config.order = :random
end
