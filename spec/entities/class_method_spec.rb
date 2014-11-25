require 'spec_helper'

describe Analyst::Entities::ClassMethod do

  let(:code) {<<-CODE
      class DefaultCarrier
        def self.register(carrier)
          CarrierRegistry.add(carrier)
        end
      end
    CODE
  }
  let(:parser) { Analyst.for_source(code) }
  let(:klass)  { parser.classes.first }
  let(:method) { klass.cmethods.first }

  describe "#name" do
    it "returns its short name" do
      expect(method.name).to eq("register")
    end
  end

  describe "#full_name" do
    it "returns its fully qualified name" do
      expect(method.full_name).to eq("DefaultCarrier::register")
    end
  end

  context "using `class << self` blocks" do

    let(:code) {<<-CODE
        class BodyBuilder
          class << self
            def generate_tanning_booth
              TanningBooth.new
            end
          end
        end
      CODE
    }

    describe "#name" do
      it "returns its short name" do
        expect(method.name).to eq("generate_tanning_booth")
      end
    end

    describe "#full_name" do
      it "returns its fully qualified name" do
        pending "must resolve out handling of singleton classes"
        expect(method.full_name).to eq("BodyBuilder::generate_tanning_booth")
      end
    end
  end
end
