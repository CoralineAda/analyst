require 'spec_helper'

describe Analyst::Entities::String do

  let(:code) {<<-CODE
      class DefaultCarrier
        def initialize
          "USPS"
        end
      end
    CODE
  }
  let(:parser) { Analyst.for_source(code) }
  let(:klass)  { parser.classes.first }
  let(:string) { klass.imethods.first.strings.first }

  describe "#value" do
    it "returns the value of the string" do
      expect(string.value).to eq("USPS")
    end
  end

end