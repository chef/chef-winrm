require "chef-winrm/psrp/message_factory"

describe WinRM::PSRP::MessageFactory do
  let(:runspace_pool_id) { "bc1bfbba-8215-4a04-b2df-7a3ac0310e16" }
  let(:pipeline_id) { "6f8b3b8a-a4e9-4a2f-9a1c-1f2e3d4c5b6a" }

  describe "template compilation" do
    before { described_class.instance_variable_set(:@compiled_templates, nil) }

    it "reads each template from disk only once" do
      allow(File).to receive(:read).and_call_original
      3.times { described_class.create_pipeline_message(runspace_pool_id, pipeline_id, "dir") }
      expect(File).to have_received(:read).once
    end

    it "reads each distinct template once" do
      allow(File).to receive(:read).and_call_original
      2.times do
        described_class.session_capability_message(runspace_pool_id)
        described_class.init_runspace_pool_message(runspace_pool_id)
      end
      expect(File).to have_received(:read).twice
    end
  end

  describe "rendered output" do
    it "renders the same payload on every call" do
      first = described_class.create_pipeline_message(runspace_pool_id, pipeline_id, "dir")
      second = described_class.create_pipeline_message(runspace_pool_id, pipeline_id, "dir")
      expect(second.data).to eq(first.data)
    end

    it "interpolates the command into the pipeline message" do
      message = described_class.create_pipeline_message(runspace_pool_id, pipeline_id, "Get-Process")
      expect(message.data).to include("Get-Process")
    end

    it "escapes XML metacharacters in the command" do
      message = described_class.create_pipeline_message(runspace_pool_id, pipeline_id, "echo <a> & 'b'")
      expect(message.data).to include("echo &lt;a&gt; &amp; 'b'")
    end
  end
end
