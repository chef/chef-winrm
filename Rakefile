require "rubygems"
require "bundler/setup"
require "rspec/core/rake_task"
require "rubocop/rake_task"
require "bundler/gem_tasks"

# Change to the directory of this file.
Dir.chdir(File.expand_path(__dir__))

desc "Open a Pry console for this library"
task :console do
  require "pry"
  require "chef-winrm"
  ARGV.clear
  Pry.start
end

RSpec::Core::RakeTask.new(:spec) do |task|
  task.pattern = "tests/spec/**/*_spec.rb"
  task.rspec_opts = ["--color", "-r ./tests/spec/spec_helper"]
end

# Run the integration test suite
RSpec::Core::RakeTask.new(:integration) do |task|
  task.pattern = "tests/integration/*_spec.rb"
  task.rspec_opts = ["--color", "-f documentation", "-r ./tests/integration/spec_helper"]
end

desc "Check Linting and code style."
task :style do
  require "rubocop/rake_task"
  require "cookstyle/chefstyle"

  if RbConfig::CONFIG["host_os"] =~ /mswin|mingw|cygwin/
    # Windows-specific command, rubocop erroneously reports the CRLF in each file which is removed when your PR is uploaeded to GitHub.
    # This is a workaround to ignore the CRLF from the files before running cookstyle.
    sh "cookstyle --chefstyle -c .rubocop.yml --except Layout/EndOfLine"
  else
    sh "cookstyle --chefstyle -c .rubocop.yml"
  end
rescue LoadError
  puts "Rubocop or Cookstyle gems are not installed. bundle install first to make sure all dependencies are installed."
end

RuboCop::RakeTask.new

task default: %i{spec style}

task all: %i{default integration}
