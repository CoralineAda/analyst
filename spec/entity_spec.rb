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

end
