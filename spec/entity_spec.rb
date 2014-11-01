require 'spec_helper'

describe Analyst::Entities::Entity do

  let(:parser) { Analyst.new("./spec/fixtures/music.rb") }
  let(:singer) { parser.classes.detect{ |klass| klass.name == "Singer" }}

  describe "#constants" do
    it "lists all constants from recursive search" do
      constants = singer.constants.select{|c| c.is_a? Analyst::Entities::Constant}
      constants = constants.map(&:full_name)
      expect(constants).to match_array(["SUPER_ATTRS", "Song"])
    end
  end

  describe "#conditionals" do
    it "lists all conditionals from recursive search" do
      conditionals = singer.imethods.map(&:conditionals).reject{|c| c.blank? }
      expect(conditionals.count).to eq(1)
    end
  end

  describe "::location" do
    context "returns the source code location" do
      before do
        @location = singer.location
      end
      it "includes the start position" do
        expect(@location.begin).to eq(198)
      end
      it "includes the end position" do
        expect(@location.end).to eq(777)
      end
    end
  end

  describe "::source" do
    let(:test_method) { singer.imethods.first }
    before do
      allow(singer).to receive(:location) { Range.new(577..683)}
    end
    it "correctly maps to the source" do
      method_text = "  def status\n    if self.album_sales > HIPSTER_THRESHOLD\n      \"sellout\"\n    else\n      \"cool\"\n    end\n  end"
      expect(test_method.source).to eq(method_text)
    end
  end

end
