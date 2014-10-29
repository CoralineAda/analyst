require 'spec_helper'
require 'pry'

describe "Parser" do

  describe "#classes" do
    let(:parser) { Analyst.new("./spec/fixtures/music.rb") }

    it "lists top-level classes" do
      expect(parser.classes.map(&:full_name)).to eq ["Artist", "Singer", "Song"]
    end

  end
end
