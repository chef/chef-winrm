require "chef-winrm"

describe "requiring chef-winrm" do
  # Guards the deferred require in WinRM::HTTP::HttpTransport#initialize. The
  # check runs in a subprocess because this one has already loaded httpclient
  # by way of the transport specs.
  it "does not load httpclient" do
    lib = File.expand_path("../../lib", __dir__)
    script = 'require "chef-winrm"; ' \
             'print $LOADED_FEATURES.any? { |f| File.basename(f) == "httpclient.rb" }'
    loaded = IO.popen([RbConfig.ruby, "-I", lib, "-e", script], &:read)

    expect(loaded).to eq("false")
  end

  it "loads httpclient once a transport is constructed" do
    lib = File.expand_path("../../lib", __dir__)
    script = 'require "chef-winrm"; ' \
             'WinRM::HTTP::HttpPlaintext.new("http://localhost:5985/wsman", "u", "p", {}); ' \
             'print $LOADED_FEATURES.any? { |f| File.basename(f) == "httpclient.rb" }'
    loaded = IO.popen([RbConfig.ruby, "-I", lib, "-e", script], &:read)

    expect(loaded).to eq("true")
  end
end
