require 'spec_helper'

describe Analyst::Entities::ConstantAssignment do

  let(:code) {<<-CODE
      module Envelope
        attr_accessor :sealed, :contents
        def seal(contents)
          self.contents = contents
          self.sealed = true
        end
      end
    CODE
  }
  let(:parser)  { Analyst.for_source(code) }
  let(:module_)   { parser.modules.first }

  describe "#imethods" do
    it "returns a list of instance methods" do
      method_names = module_.imethods.map(&:name)
      expect(method_names).to match_array ["seal"]
    end
  end

end