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

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "solargraph"
  spec.add_development_dependency "standard"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-rails"
  spec.add_development_dependency "rubocop-performance"
  spec.add_development_dependency "rubocop-rspec"
  spec.add_development_dependency "rubocop-rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-rails"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "pry-doc"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html

  # Dependencies for dummy test app (start)
  spec.add_development_dependency "rails"
  spec.add_development_dependency "sprockets-rails"
  spec.add_development_dependency "sqlite3", "~> 1.4"
  spec.add_development_dependency "puma", "~> 5.0"
  spec.add_development_dependency "importmap-rails"
  spec.add_development_dependency "turbo-rails"
  spec.add_development_dependency "stimulus-rails"
  spec.add_development_dependency "jbuilder"
  spec.add_development_dependency "bootsnap"
  spec.add_development_dependency "web-console"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "dotenv-rails"
  # Dependencies for dummy test app (end)
end
