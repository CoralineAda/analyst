require 'spec_helper'

describe Analyst::Entities::Entity do

  let(:parser) { Analyst.new("./spec/fixtures/music.rb") }
  let(:singer) { parser.classes.detect{ |klass| klass.name == "Singer" }}

  describe "#constants" do
    it "lists all constants from recursive search" do
      constants = singer.constants.map(&:full_name)
      expected = %w[SUPER_ATTRS HIPSTER_THRESHOLD HIPSTER_THRESHOLD Song Performance::Equipment::Microphone]
      # TODO: once (casgn) is done, expected should contain one more
      # SUPER_ATTRS and one more HIPSTER_THRESHOLD

      expect(constants).to match_array expected
    end

    it "finds constants inside of Arrays" do
      code = <<-CODE
        class Mail
          def things
            [Stamp, Envelope, Postcard]
          end
        end
      CODE

      found = Analyst.for_source(code).constants.map(&:full_name)
      expect(found).to match_array %w[Stamp Envelop Postcard]
    end

    it "finds constants inside of method calls" do
      code = <<-CODE
        class Mail
          def deliver
            ship_to(PostOffice.nearest_to(recipient))
          end
        end
      CODE

      found = Analyst.for_source(code).constants.map(&:full_name)
      expect(found).to match_array %w[PostOffice]
    end

    it "finds constants inside of parenthetical expressions" do
      code = "def fn; A + (B || C); end"
      found = Analyst.for_source(code).constants.map(&:full_name)
      expect(found).to match_array %w[A B C]
    end
  end

  describe "#conditionals" do
    it "lists all conditionals from recursive search" do
      conditionals = singer.imethods.map(&:conditionals).reject{|c| c.blank? }
      expect(conditionals.count).to eq(1)
    end
  end

  describe "#location" do
    let(:code) do <<-CODE
class Foo
  attr_accessor :bar
end

class Baz
  def initialize
    puts "Fresh Baz!"
  end
end
    CODE
    end

    let(:parser) { Analyst.for_source(code) }

    context "returns the source code location" do
      let(:baz) { parser.classes.detect {|klass| klass.name == "Baz"} }
      let(:location) { baz.location }

      it "includes the start position" do
        expect(location.begin).to eq code.index("class Baz")
      end

      it "includes the end position" do
        expect(location.end).to eq code.size
      end
    end
  end

  describe "#source" do
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
