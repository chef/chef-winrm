require "stringio"
require "chef-winrm"
require "chef-winrm/compat_logger"

RSpec.describe WinRM::CompatLogger do
  let(:io) { StringIO.new }
  let(:logger) { WinRM::CompatLogger.new(io) }

  it "is a stdlib Logger" do
    expect(logger).to be_a(::Logger)
  end

  it "logs through the standard API" do
    logger.level = :debug
    logger.info("hello")
    expect(io.string).to include("hello")
  end

  it "accepts add_appenders with a deprecation warning instead of raising" do
    expect { logger.add_appenders(:stdout) }.not_to raise_error
    expect { WinRM::CompatLogger.new(io).add_appenders(:stdout) }
      .to output(/DEPRECATION.*add_appenders/).to_stderr
  end

  it "warns only once per instance" do
    expect { logger.add_appenders(:stdout) }.to output(/DEPRECATION/).to_stderr
    expect { logger.add_appenders(:stdout) }.not_to output.to_stderr
  end
end

RSpec.describe "WinRM.default_log_level" do
  around do |example|
    original = ENV.fetch("WINRM_LOG", nil)
    example.run
    ENV["WINRM_LOG"] = original
  end

  it "defaults to warn when WINRM_LOG is unset" do
    ENV.delete("WINRM_LOG")
    expect(WinRM.default_log_level).to eq(:warn)
  end

  it "defaults to warn when WINRM_LOG is empty" do
    ENV["WINRM_LOG"] = ""
    expect(WinRM.default_log_level).to eq(:warn)
  end

  it "honors a valid level" do
    ENV["WINRM_LOG"] = "debug"
    expect(WinRM.default_log_level).to eq(:debug)
  end

  it "is case insensitive" do
    ENV["WINRM_LOG"] = "DEBUG"
    expect(WinRM.default_log_level).to eq(:debug)
  end

  it "warns and falls back to warn for an invalid level" do
    ENV["WINRM_LOG"] = "chatty"
    expect { expect(WinRM.default_log_level).to eq(:warn) }
      .to output(/Invalid WINRM_LOG level is set: chatty/).to_stderr
  end
end
