require 'spec_helper'

describe Analyst::Entities::MethodCall do

  describe "#constants" do
    let(:code) { "Universe.spawn(Star, into: Galaxy.named('Milky Way'))" }
    let(:method_call) { Analyst.for_source(code).method_calls.first }

    it "lists constant targets and arguments" do
      found = method_call.constants.map(&:name)
      expect(found).to match_array %w[Universe Star Galaxy]
    end
  end

  describe "#arguments" do
    it "lists arguments" do
      code = "fn(:one, 'two', three)"
      args = Analyst.for_source(code).method_calls.first.arguments

      expect(args[0].value).to be :one
      expect(args[1].value).to eq 'two'
      expect(args[2].class).to eq Analyst::Entities::MethodCall
      expect(args[2].name).to eq 'three'
    end
  end
end
