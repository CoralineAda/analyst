require 'spec_helper'

describe "Parser" do

  let(:parser) { Analyst.for_file("./spec/fixtures/music/music.rb") }

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
                       Performances::Equipment::Microphone
                       Performances::Equipment::MicStand
                     ]

      class_names = parser.classes.map(&:full_name)

      expect(class_names).to match_array all_classes
    end
  end

  describe "#constants" do
    let(:code) { "Nice::Static::Constant; stupid.dynamic::Constant; @another.stupid::Constant" }
    let(:parser) { Analyst.for_source(code) }

    it "recognizes static constants" do
      expect(parser.constants.map(&:name)).to include("Nice::Static::Constant")
    end

    it "recognizes dynamically-named constants" do
      dynamic_constants = %w[<`stupid.dynamic`>::Constant <`@another.stupid`>::Constant]
      expect(parser.constants.map(&:name)).to include(*dynamic_constants)
    end
  end

  describe "::for_source" do
    context "with syntax errors" do
      let(:code) {<<-CODE
        class Mail
          def deliver
            ship_to(PostOffice.nearest_to(recipient))
          end
        end

        count_those_parentheses())
      CODE
      }

      let(:parser) { Analyst.for_source(code) }

      it "reports the error" do
        error_line = Regexp.new(Regexp.quote("count_those_parentheses())"))
        expect { parser }.to output(error_line).to_stderr
      end

      it "aborts parsing" do
        allow($stderr).to receive(:puts) # suppress error reporting in spec output
        expect(parser.classes).to be_empty
      end
    end
  end

  describe "::for_files" do
    context "with syntax errors" do
      let(:parser) { Analyst.for_files("./spec/fixtures/syntax_errors/") }

      it "reports the error" do
        error_line = Regexp.new(Regexp.quote("def illegal+character"))
        expect { parser }.to output(error_line).to_stderr
      end

      it "omits the bad files, but parses the good ones" do
        allow($stderr).to receive(:puts) # suppress error reporting in spec output
        expect(parser.classes.map(&:name)).to eq ['Good']
      end
    end
  end

end

