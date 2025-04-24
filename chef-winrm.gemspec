require "date"
require File.expand_path("lib/chef-winrm/version", __dir__)

Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = "chef-winrm"
  s.version = WinRM::VERSION

  s.author = ["Dan Wanek", "Paul Morton", "Matt Wrock", "Shawn Neal"]
  s.email = [
    "dan.wanek@gmail.com",
    "paul@themortonsonline.com",
    "matt@mattwrock.com",
    "sneal@sneal.net",
  ]
  s.homepage = "https://github.com/WinRb/WinRM"

  s.summary = "Ruby library for Windows Remote Management"
  s.description = <<-EOF
    Ruby library for Windows Remote Management
  EOF
  s.license = "Apache-2.0"

  s.files = Dir.glob("{bin,lib}/**/*") + %w{LICENSE README.md}
  s.require_path = "lib"
  s.rdoc_options = %w{-x test/ -x examples/}
  s.extra_rdoc_files = %w{README.md LICENSE}

  s.bindir = "bin"
  s.executables = ["rwinrm"]
  s.required_ruby_version = ">= 3.1"
  s.add_dependency "builder", ">= 2.1.2"
  s.add_dependency "chef-gyoku", "~> 1.5"
  s.add_dependency "erubi", "~> 1.8"
  s.add_dependency "gssapi", "~> 1.2"
  s.add_dependency "httpclient", "~> 2.2", ">= 2.2.0.2"
  s.add_dependency "logging", [">= 1.6.1", "< 3.0"]
  s.add_dependency "nori", "= 2.7.0" # nori 2.7.1 has a bug where it throws a NoMethodError for snakecase.
  s.add_dependency "rexml", "~> 3.3" # needs to load at least 3.3.6 to get past a CVE
  s.add_development_dependency "pry"
  s.add_development_dependency "rake", ">= 10.3", "< 13"
  s.add_development_dependency "ostruct"
  s.add_development_dependency "fiddle"
  s.add_development_dependency "benchmark"
  s.add_development_dependency "rb-readline"
  s.add_development_dependency "syslog"
  s.add_development_dependency "rspec", "~> 3.2"
  s.add_development_dependency "cookstyle", ">= 8.0.0"
  s.add_dependency "rubyntlm", "~> 0.6.0", ">= 0.6.3"

  s.metadata["rubygems_mfa_required"] = "true"
end
