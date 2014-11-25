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

  describe "#fulL_name" do
    it "returns its fully qualified name" do
      expect(method.full_name).to eq("DefaultCarrier::register")
    end
  end

end