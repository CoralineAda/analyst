require 'spec_helper'

describe Analyst::Entities::InstanceMethod do

  let(:code) {<<-CODE
      class DefaultCarrier
        def initialize
          @foo = "bar"
        end
      end
    CODE
  }
  let(:parser) { Analyst.for_source(code) }
  let(:klass)  { parser.classes.first }
  let(:method) { klass.imethods.first }

  describe "#name" do
    it "returns its short name" do
      expect(method.name).to eq("initialize")
    end
  end

  describe "#fulL_name" do
    it "returns its fully qualified name" do
      expect(method.full_name).to eq("DefaultCarrier#initialize")
    end
  end

end