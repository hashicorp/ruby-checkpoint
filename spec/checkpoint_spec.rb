require "helper"

describe Checkpoint do
  describe ".check" do
    context "with a proper request" do
      subject do
        described_class.check(
          product: "test",
          version: "1.0",
        )
      end

      its(["alerts"]) { should be_empty }
      its(["current_version"]) { should eq("1.0") }
      its(["outdated"]) { should eq(false) }
      its(["product"]) { should eq("test") }
    end
  end
end
