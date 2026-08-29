require "chef-winrm/psrp/message_defragmenter"

describe WinRM::PSRP::MessageDefragmenter do
  context "a real life fragment" do
    let(:bytes) do
      "\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x01\x03\x00\x00\x00I\x01"\
      "\x00\x00\x00\x04\x10\x04\x00Kk/=Z\xD3-E\x81v\xA0+6\xB1\xD3\x88\n\xED\x90\x9Cj\xE7PG"\
      "\x9F\xA2\xB2\xC99to9\xEF\xBB\xBF<S>some data_x000D__x000A_</S>".to_byte_string
    end
    subject { described_class.new.defragment(Base64.encode64(bytes)) }

    it "parses the data" do
      expect(subject.data).to eq("\xEF\xBB\xBF<S>some data_x000D__x000A_</S>".to_byte_string)
    end

    it "parses the destination" do
      expect(subject.destination).to eq(1)
    end

    it "parses the message type" do
      expect(subject.type).to eq(WinRM::PSRP::Message::MESSAGE_TYPES[:pipeline_output])
    end
  end

  context "multiple fragments" do
    let(:blob) do
      WinRM::PSRP::Message.new(
        "bc1bfbba-8215-4a04-b2df-7a3ac0310e16",
        WinRM::PSRP::Message::MESSAGE_TYPES[:session_capability],
        "This is a fragmented message"
      )
    end
    let(:fragment1) { WinRM::PSRP::Fragment.new(1, blob.bytes[0..5], 0, true, false) }
    let(:fragment2) { WinRM::PSRP::Fragment.new(1, blob.bytes[6..10], 1, false, false) }
    let(:fragment3) { WinRM::PSRP::Fragment.new(1, blob.bytes[11..-1], 2, false, true) }

    it "pieces the message together" do
      subject.defragment(Base64.strict_encode64(fragment1.bytes.pack("C*")))
      subject.defragment(Base64.strict_encode64(fragment2.bytes.pack("C*")))
      message = subject.defragment(Base64.strict_encode64(fragment3.bytes.pack("C*")))

      expect(message.data[3..-1]).to eq(blob.data)
    end
  end

  context "many fragments from interleaved messages" do
    let(:message) do
      WinRM::PSRP::Message.new(
        "bc1bfbba-8215-4a04-b2df-7a3ac0310e16",
        WinRM::PSRP::Message::MESSAGE_TYPES[:pipeline_output],
        "<S>#{"chunky bacon " * 500}</S>"
      )
    end

    def wire(object_id)
      bytes = message.bytes
      fragments = []
      offset = 0
      until offset >= bytes.length
        last = [offset + 64, bytes.length].min
        fragments << WinRM::PSRP::Fragment.new(
          object_id, bytes[offset..last - 1], fragments.length, offset == 0, last == bytes.length
        )
        offset = last
      end
      fragments.map { |f| Base64.strict_encode64(f.bytes.pack("C*")) }
    end

    it "reassembles a message spanning many fragments in order" do
      stream = wire(1)
      expect(stream.length).to be > 50
      results = stream.map { |f| subject.defragment(f) }.compact
      expect(results.length).to eq(1)
      expect(results.first.data[3..-1]).to eq(message.data.b)
    end

    it "keeps interleaved messages separate" do
      a = wire(1)
      b = wire(2)
      results = a.zip(b).flatten.compact.map { |f| subject.defragment(f) }.compact
      expect(results.length).to eq(2)
      expect(results.map { |m| m.data[3..-1] }.uniq).to eq([message.data.b])
    end
  end
end
