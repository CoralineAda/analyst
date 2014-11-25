require 'spec_helper'

describe Analyst::Entities::ConstantAssignment do

  let(:code) {<<-CODE
      class Carrier
        OBSTACLES = [:rain, :sleet, :snow]
        def deliver(mail)
          delivery = Delivery.new(mail)
          delivery.deliver!
        end
      end
    CODE
  }
  let(:parser)  { Analyst.for_source(code) }
  let(:klass)   { parser.classes.first }
  let(:constant_assignment) { klass.constant_assignments.first }

  describe "#name" do
    it "returns the short name of a constant" do
      expect(constant_assignment.name).to eq("OBSTACLES")
    end
  end

  describe "#full_name" do
    it "returns the full name of a constant" do
      expect(constant_assignment.full_name).to eq("Carrier::OBSTACLES")
    end
  end

end