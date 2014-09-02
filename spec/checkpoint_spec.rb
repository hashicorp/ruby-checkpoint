require "tempfile"

require "helper"

describe Checkpoint do
  describe ".check" do
    context "with a proper request" do
      subject do
        described_class.check(
          product: "test",
          version: "1.0",
          raise_error: true,
        )
      end

      its(["alerts"]) { should be_empty }
      its(["current_version"]) { should eq("1.0") }
      its(["outdated"]) { should eq(false) }
      its(["product"]) { should eq("test") }
    end

    it "should cache things with cache_file" do
      tf = Tempfile.new("checkpoint")
      path = tf.path
      tf.close
      File.unlink(path)

      opts = {
        product: "test",
        version: "1.0",
        cache_file: path,
      }

      # Just run it twice
      c = described_class.check(opts)
      c = described_class.check(opts)

      expect(c["product"]).to eq("test")
    end
  end
end
