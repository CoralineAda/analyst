require 'spec_helper'

describe Analyst::Entities::Hash do

  describe "#to_hash" do
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
    end
  end
end
