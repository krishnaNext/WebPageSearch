require "spec_helper"
require "./lib/keyword"

RSpec.describe Keyword do
  let(:keyword) { described_class.new("word", 1) }

  context "#attr_accessor" do
    it "should respond to #name" do
      expect(keyword).to respond_to(:name)
    end

    it "should respond to #name=" do
      expect(keyword).to respond_to(:name=)
    end

    it "should respond to #weight" do
      expect(keyword).to respond_to(:weight)
    end

    it "should respond to #weight=" do
      expect(keyword).to respond_to(:weight=)
    end
  end

  context "#instance methods" do
    context "#same?" do
      context "when the keyword is created with a same name and a same weight" do
        let(:keyword2) { described_class.new("word", 1) }

        it "should return true" do
          expect(keyword.same?(keyword2)).to be_truthy
        end
      end

      context "when the keyword is created with a same name(but in upcase) and a same weight" do
        let(:keyword2) { described_class.new("WORD", 1) }

        it "should return true" do
          expect(keyword.same?(keyword2)).to be_truthy
        end
      end

      context "when the keyword is created with a same name and a different weight" do
        let(:keyword2) { described_class.new("word", 2) }

        it "should return true" do
          expect(keyword.same?(keyword2)).to be_truthy
        end
      end

      context "when the keyword is created with a different name and a same weight" do
        let(:keyword2) { described_class.new("wordless", 1) }

        it "should return false" do
          expect(keyword.same?(keyword2)).to be_falsey
        end
      end

      context "when the keyword is created with different name and different weight" do
        let(:keyword2) { described_class.new("wordless", 2) }

        it "should return false" do
          expect(keyword.same?(keyword2)).to be_falsey
        end
      end
    end
  end
end
