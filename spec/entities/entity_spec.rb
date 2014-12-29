require 'spec_helper'

describe Analyst::Entities::Entity do

  let(:parser) { Analyst.for_file("./spec/fixtures/music/music.rb") }
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
      expect(found).to match_array %w[Stamp Envelope Postcard]
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

    it "finds constants inside of interpolated strings" do
      code = 'str = "Today, scientists classify Pluto as a #{Pluto.wtfru?}"'
      found = Analyst.for_source(code).constants.map(&:name)
      expect(found).to match_array %w[Pluto]
    end
  end

  describe "#conditionals" do
    it "lists all conditionals from recursive search" do
      # TODO: test recursive search frd -- i.e. conditionals inside of conditionals
      conditionals = singer.imethods.map(&:conditionals).flatten
      expect(conditionals.count).to eq(1)
    end
  end

  describe "#file_path" do
    let(:parser) { Analyst.for_files("./spec/fixtures/music") }
    let(:singer) { parser.classes.detect { |klass| klass.name == "Singer" } }

    it "reports the path of the source file" do
      expect(singer.file_path).to eq "./spec/fixtures/music/music.rb"
    end

    it "works for non-top-level Entities too" do
      a_method = singer.methods.first
      expect(a_method.file_path).to eq "./spec/fixtures/music/music.rb"
    end

    context "when the source is a string" do
      let(:parser) { Analyst.for_source("class Foo; end") }
      let(:foo_class) { parser.classes.first }

      it "returns '(string)'" do
        expect(foo_class.file_path).to eq '(string)'
      end
    end
  end

  describe "#location" do
    let(:parser) { Analyst.for_files("./spec/fixtures/music") }
    let(:singer) { parser.classes.detect { |klass| klass.name == "Singer" } }
    let(:songs)  { singer.imethods.detect { |meth| meth.name == "songs" } }

    it "reports the location of the source for the entity" do
      expect(songs.location).to eq "./spec/fixtures/music/music.rb:41"
    end
  end

  describe "#source" do
    let(:test_method) { singer.imethods.first }

    it "correctly maps to the source" do
      method_text = "def status\n    if self.album_sales > HIPSTER_THRESHOLD\n      \"sellout\"\n    else\n      \"cool\"\n    end\n  end"

      expect(test_method.source).to eq(method_text)
    end
  end

  describe "#method_calls" do
    it "detects method calls" do
      code = 'do_that_thang'
      found = Analyst.for_source(code).method_calls.map(&:name)
      expect(found).to match_array %w[do_that_thang]
    end

    it "detects calls inside calls" do
      code = 'do_that_thang(with_this_stuff)'
      do_that_thang = Analyst.for_source(code).method_calls.first
      found = do_that_thang.method_calls.map(&:name)
      expect(found).to match_array %w[with_this_stuff]
    end

  end

end
