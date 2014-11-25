require 'spec_helper'

describe Analyst::Entities::Hash do

  let(:code) {<<-CODE
      class Postmark
        attr_accessor :date, :origin_city
        def to_hash
          {
            date: self.date,
            sent_from: self.origin_city
          }
        end
      end
    CODE
  }
  let(:parser)  { Analyst.for_source(code) }
  let(:klass)   { parser.classes.first }
  let(:methods) { klass.imethods }

  describe "#pairs" do
    let(:pairs) { methods.map(&:hashes).flatten.first.pairs }

    it "extracts key/value pairs" do
      expect(pairs.map(&:class)).to eq(
        [Analyst::Entities::Pair, Analyst::Entities::Pair]
      )
    end
  end

  describe "#to_hash" do
    let(:hash_entity) { methods.map(&:hashes).flatten.first }
    it "returns a hash with appropriate keys" do
      expect(hash_entity.to_hash.keys).to eq(
        [:date, :sent_from]
      )
    end
    it "returns a hash with appropriate values" do
      expect(hash_entity.to_hash.values.map(&:class)).to eq(
        [Analyst::Entities::MethodCall, Analyst::Entities::MethodCall]
      )
    end
  end

end