require 'spec_helper'

describe Analyst::Entities::Class do

  let(:parser) { Analyst.new("./spec/fixtures/music.rb") }
  let(:artist) { parser.classes.detect { |klass| klass.full_name == "Artist" } }
  let(:singer) { parser.classes.detect { |klass| klass.full_name == "Singer" } }

  describe "#method_calls" do
    it "lists all method invocations within a class definition" do
      macro_names = artist.macros.map(&:name)
      expect(macro_names).to match_array ["attr_accessor"]
    end
  end

  describe "#imethods" do
    it "returns a list of instance methods" do
      method_names = artist.imethods.map(&:name)
      expect(method_names).to match_array ["initialize", "starve"]
    end
  end

  describe "#cmethods" do
    it "returns a list of class methods" do
      class_method_names = singer.cmethods.map(&:name)
      expect(class_method_names).to match_array ["superstar", "sellouts"]
    end
  end

end
