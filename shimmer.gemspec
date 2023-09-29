# frozen_string_literal: true

require_relative "lib/shimmer/version"

Gem::Specification.new do |spec|
  spec.name = "shimmer"
  spec.version = Shimmer::VERSION
  spec.authors = ["Jens Ravens"]
  spec.email = ["jens@nerdgeschoss.de"]

  spec.summary = "Shimmer brings all the bells and whistles of a hotwired application, right from the start."
  spec.homepage = "https://github.com/nerdgeschoss/shimmer"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_runtime_dependency "thumbhash"
end
