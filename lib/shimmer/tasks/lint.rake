# frozen_string_literal: true

desc "Executes all linters and tests"
task :lint do
  sh "bin/rubocop"
  sh "yarn lint"
  sh "i18n-tasks health"
  sh "bin/rspec"
end
