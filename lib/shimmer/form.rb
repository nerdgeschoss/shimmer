# frozen_string_literal: true

module Shimmer
  module Form
  end
end

require_relative "form/builder"
require_relative "form/field"

Dir["#{File.expand_path("./form", __dir__)}/*"].sort.each do |e|
  require e
  name = e.split("/").last.delete_suffix(".rb")
  next unless name.end_with?("_field")
  Shimmer::Form::Builder.register("Shimmer::Form::#{name.classify}".constantize)
end
