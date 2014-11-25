require 'spec_helper'

describe Analyst::Entities::Constant do

  describe "#name" do
    context "with top-level scoping" do
      let(:source) { "::Food::Pizza::Hawaiian" }

      it "correctly reports the name" do
        analyzer = Analyst.for_source(source)
        expect(analyzer.constants.first.name).to eq source
      end
    end

    context "without a scope" do
      let(:source) { "Body::Organs::Pancreas" }

      it "correctly reports the name" do
        analyzer = Analyst.for_source(source)
        expect(analyzer.constants.first.name).to eq source
      end

    end
  end

end
