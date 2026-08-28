require "rubygems"
require "bundler/setup"
require "chef-winrm"
require "json"
require_relative "../matchers"

# Unit test spec helper
module SpecUnitHelper
  def stubbed_response(file)
    File.read("tests/spec/stubs/responses/#{file}")
  end

  def stubbed_clixml(file)
    File.read("tests/spec/stubs/clixml/#{file}")
  end

  # Strips the leading whitespace that matches the first line's indentation from
  # every line, leaving any _additional_ indentation intact, and removes newlines.
  def unindent(string)
    string.gsub(/^#{string[/\A[ \t]*/]}/, "").delete("\n")
  end

  def to_byte_string(string)
    string.dup.force_encoding(Encoding::ASCII_8BIT)
  end

  def default_connection_opts
    {
      user: "Administrator",
      password: "password",
      endpoint: "http://localhost:5985/wsman",
      max_envelope_size: 153600,
      session_id: "05A2622B-B842-4EB8-8A78-0225C8A993DF",
      operation_timeout: 60,
      locale: "en-US",
    }
  end
end

RSpec.configure do |config|
  config.include(SpecUnitHelper)
  config.raise_errors_for_deprecations!

  # Require RSpec.describe rather than a top level describe, and drop the
  # should syntax, so the specs stop monkey patching every object in the suite.
  config.disable_monkey_patching!

  # Fail a spec that stubs a method the real object does not define, which is
  # the main way stubbed specs rot without anyone noticing.
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # Surface order dependencies between examples. The seed is printed on every
  # run so a failure can be reproduced with --seed.
  config.order = :random
  Kernel.srand config.seed
end
