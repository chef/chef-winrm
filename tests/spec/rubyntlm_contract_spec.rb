require "net/ntlm"

# The negotiate transport calls @ntlmcli.session.seal_message and
# unseal_message, which derive their keys from these four methods. rubyntlm
# 0.6.7 broke all four by moving them into Net::NTLM::Client::SessionCrypto
# while leaving the key constants in Net::NTLM::Client::Session, so they
# raise NameError at runtime.
#
# Nothing in the unit suite exercised that path, so the breakage only
# surfaced in the integration suite, which needs a live Windows host. These
# examples pin the dependency contract instead, failing in seconds.
describe "rubyntlm session key derivation" do
  let(:session) do
    Net::NTLM::Client::Session.allocate.tap do |s|
      allow(s).to receive(:exported_session_key).and_return("0123456789abcdef")
    end
  end

  %i{client_seal_key server_seal_key client_sign_key server_sign_key}.each do |key|
    it "derives #{key} without raising" do
      expect { session.send(key) }.not_to raise_error
      expect(session.send(key).bytesize).to eq(16)
    end
  end
end
