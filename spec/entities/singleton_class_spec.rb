require 'spec_helper'

describe Analyst::Entities::SingletonClass do

  let(:code) {<<-CODE
      class FriendlyStaff
        class << self
          def greet_customers
            "Hello customers!"
          end
        end
      end
    CODE
  }
  let(:parser) { Analyst.for_source(code) }
  let(:klass)  { parser.classes.first }
  let(:singleton) { klass.singleton_class_blocks.first }

  describe "#name" do
    it "returns its short name" do
      expect(singleton.name).to eq("FriendlyStaff!SINGLETON")
    end
  end

  describe "#fulL_name" do
    it "returns its fully qualified name" do
      expect(singleton.full_name).to eq("FriendlyStaff!SINGLETON")
    end
  end

  describe "#smethods" do
    it "returns its singleton methods" do
      expect(singleton.smethods.first.name).to eq("greet_customers")
    end
  end

end