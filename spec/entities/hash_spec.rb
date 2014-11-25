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

    describe "`extract_values` option" do
      let(:code) { "{ :name => 'Jim', :sex => :male, Coolness => get_coolness }" }
      let(:hash) { Analyst.for_source(code).hashes.first }

      context "with `extract_values: true` (default)" do
        let(:hash_frd) { hash.to_hash }

        it "extracts symbols and strings" do
          coolness = hash.constants.first
          get_coolness = hash.pairs.last.method_calls.first

          expect(hash_frd.keys).to match_array [:name, :sex, coolness]
          expect(hash_frd.values).to match_array ['Jim', :male, get_coolness]
        end
      end

      context "with `extract_values: false`" do
        let(:hash_frd) { hash.to_hash(extract_values: false) }

        it "returns Entities instead of primitives" do
          key_classes = hash_frd.keys.map(&:class)
          value_classes = hash_frd.values.map(&:class)

          expect(key_classes).to eq [Analyst::Entities::Symbol, Analyst::Entities::Symbol, Analyst::Entities::Constant]
          expect(value_classes).to eq [Analyst::Entities::String, Analyst::Entities::Symbol, Analyst::Entities::MethodCall]
        end
      end
    end
  end
end
