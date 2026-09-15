require "chef-winrm/wsmv/receive_response_reader"

RSpec.describe WinRM::WSMV::ReceiveResponseReader do
  let(:shell_id) { "F4A2622B-B842-4EB8-8A78-0225C8A993DF" }
  let(:command_id) { "A2A2622B-B842-4EB8-8A78-0225C8A993DF" }
  let(:output_message) { double("output_message", build: "output_message") }
  let(:transport) { double("transport") }

  subject do
    described_class.new(
      transport,
      Logging.logger["test"]
    )
  end

  # Output from the PowerShell endpoint and output from the OMI Server endpoint.
  # An OMI server does not include a stdout stream once CommandState is Done, so
  # the stdout expectations below only apply to the PowerShell response.
  [
    {
      template: "get_command_output_response.xml.erb",
      template_not_done: "get_command_output_response_not_done.xml.erb",
      includes_stdout: true,
    },
    {
      template: "get_omi_command_output_response.xml.erb",
      template_not_done: "get_omi_command_output_response_not_done.xml.erb",
      includes_stdout: false,
    },
  ].each do |fixture|
    template = fixture[:template]
    template_not_done = fixture[:template_not_done]
    describe "#read_output for #{template}" do
      context "response doc stdout with invalid UTF-8 characters, issue 184" do
        let(:test_data_stdout) { "ffff" } # Base64-decodes to '}\xF7\xDF', an invalid sequence
        let(:test_data_stderr) { "" }
        let(:test_data_xml)    { ERB.new(stubbed_response(template)).result(binding) }
        let(:test_data)        { REXML::Document.new(test_data_xml) }

        before do
          allow(transport).to receive(:send_request).and_return(test_data)
        end

        it "does not raise an ArgumentError: invalid byte sequence in UTF-8" do

          expect do
            subject.read_output(output_message)
          end.not_to raise_error
        rescue RSpec::Expectations::ExpectationNotMetError => e
          expect(e.message).not_to include "ArgumentError"

        end

        if fixture[:includes_stdout]
          it "does not have an empty stdout" do
            expect(
              subject.read_output(output_message).stdout
            ).not_to be_empty
          end
        end
      end

      context "response doc stdout with valid UTF-8" do
        let(:test_data_raw)    { "✓1234-äöü" }
        let(:test_data_stdout) { Base64.encode64(test_data_raw) }
        let(:test_data_stderr) { "" }
        let(:test_data_xml)    { ERB.new(stubbed_response(template)).result(binding) }
        let(:test_data)        { REXML::Document.new(test_data_xml) }

        before do
          allow(transport).to receive(:send_request).and_return(test_data)
        end

        if fixture[:includes_stdout]
          it "decodes to match input data" do
            expect(
              subject.read_output(output_message).stdout
            ).to eq(test_data_raw)
          end
        end
      end
    end

    describe "#read_response for #{template}" do
      context "do not wait for done state" do
        let(:test_data_raw) { "output text" }
        let(:test_error_raw) { "error text" }
        let(:test_data_stdout) { Base64.encode64(test_data_raw) }
        let(:test_data_stderr) { Base64.encode64(test_error_raw) }
        let(:test_data_xml)    { ERB.new(stubbed_response(template)).result(binding) }

        before do
          allow(transport).to receive(:send_request).and_return(
            REXML::Document.new(test_data_xml)
          ).once
        end

        it "yields stream and document" do
          subject.read_response(output_message) do |stream, doc|
            expect(stream[:text]).to eq(test_data_stdout) if stream[:type] == :stdout
            expect(stream[:text]).to eq(test_data_stderr) if stream[:type] == :stderr
            expect(doc.to_s).to eq(REXML::Document.new(test_data_xml).to_s)
          end
        end
      end

      context "wait for done state" do
        let(:test_data_raw) { "output text" }
        let(:test_error_raw) { "error text" }
        let(:test_data_stdout) { Base64.encode64(test_data_raw) }
        let(:test_data_stderr) { Base64.encode64(test_error_raw) }
        let(:test_data_xml_notdone) { ERB.new(stubbed_response(template_not_done)).result(binding) }
        let(:test_data_xml_done) { ERB.new(stubbed_response(template)).result(binding) }

        it "yields streams and both documents" do
          allow(transport).to receive(:send_request).and_return(
            REXML::Document.new(test_data_xml_notdone),
            REXML::Document.new(test_data_xml_done)
          )
          times = 1

          subject.read_response(output_message, true) do |stream, doc|
            expect(stream[:text]).to eq(test_data_stdout) if stream[:type] == :stdout
            expect(stream[:text]).to eq(test_data_stderr) if stream[:type] == :stderr
            expect(doc.to_s).to eq(REXML::Document.new(test_data_xml_notdone).to_s) if times == 1
            expect(doc.to_s).to eq(REXML::Document.new(test_data_xml_done).to_s) if times > 2
            times += 1
          end
        end
      end
    end
  end
end
