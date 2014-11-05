require 'spec_helper'

describe "Parser" do

  let(:parser) { Analyst.for_file("./spec/fixtures/music.rb") }

  describe "#top_level_classes" do

    it "lists top-level classes" do
      class_names = parser.top_level_classes.map(&:full_name)
      expect(class_names).to match_array ["Artist", "Singer", "Song"]
    end

  end

  describe "#classes" do
    it "lists all classes from recursive search" do
      all_classes = %w[Artist Singer Song
                       Instruments::Stringed Instruments::Guitar
                       Performances::Equipment::Amp
                       Performances::Equipment::Microphone]

      class_names = parser.classes.map(&:full_name)

      expect(class_names).to match_array all_classes
    end
  end

end

