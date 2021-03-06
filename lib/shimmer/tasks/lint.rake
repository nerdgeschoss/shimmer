# frozen_string_literal: true

desc "Executes all linters and tests"
task :lint do
  sh "bundle exec standardrb --fix"
  sh "yarn lint"
  sh "i18n-tasks health"
  sh "bin/rspec"
end
