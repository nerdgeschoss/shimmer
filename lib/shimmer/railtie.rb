# frozen_string_literal: true

module Shimmer
  class Railtie < Rails::Railtie
    rake_tasks do
      path = File.expand_path(__dir__)
      Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }
    end
  end
end

ActiveSupport.on_load(:action_view) do
  Dir.glob("#{File.expand_path(__dir__)}/helpers/**/*.rb").each do |file|
    load file
    name = file.split("/").last.delete_suffix(".rb").classify
    include "Shimmer::#{name}".constantize
  end
end
