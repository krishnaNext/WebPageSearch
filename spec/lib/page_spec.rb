require "spec_helper"
require "./lib/keyword"
require "./lib/page"
require "./lib/query"

RSpec.describe Page do
  let!(:page) { described_class.new("P Hello World Web") }

  after(:each) do
    described_class.class_variable_set :@@all, []
    described_class.class_variable_set :@@count, 0
  end

  context "#attr_accessor" do
    it "should respond to #name" do
      expect(page).to respond_to(:name)
    end

    it "should respond to #name=" do
      expect(page).to respond_to(:name=)
    end

    it "should respond to #keywords" do
      expect(page).to respond_to(:keywords)
    end

    it "should respond to #keywords=" do
      expect(page).to respond_to(:keywords=)
    end
  end

  context "#instance methods" do
    context "#private methods" do
      context "#parse_keywords" do
        let(:parsed_result)         { page.send(:parse_keywords, "Hello World Web") }
        let(:parsed_keword_names)   { parsed_result.map(&:name) }
        let(:parsed_keword_weights) { parsed_result.map(&:weight) }

        it "should return parsed keywords array" do
          expect(parsed_keword_names).to match_array(["Hello", "World", "Web"])
          expect(parsed_keword_weights).to match_array([Page::MAX_WEIGHT, Page::MAX_WEIGHT - 1, Page::MAX_WEIGHT - 2])
        end
      end

      context "#relevance_score" do
        let(:query_keyword)  { Keyword.new("Hello", Query::MAX_WEIGHT) }
        let(:query_keyword2) { Keyword.new("World", Query::MAX_WEIGHT - 1) }

        it "should return the valid relevance score for the passed keyword" do
          expect(page.send(:relevance_score, query_keyword)).to eq(
            Page::MAX_WEIGHT * Query::MAX_WEIGHT
          )

          expect(page.send(:relevance_score, query_keyword2)).to eq(
            (Page::MAX_WEIGHT - 1) * (Query::MAX_WEIGHT - 1)
          )
        end
      end
    end

    context "#public methods" do
      context "#score" do
        let(:query)                          { Query.new("Q Hello World") }
        let(:query_keyword1_relevance_score) { page.send(:relevance_score, query.keywords[0]) }
        let(:query_keyword2_relevance_score) { page.send(:relevance_score, query.keywords[1]) }

        it "should return the valid score for the passed query" do
          expect(page.score(query)).to eq(
            query_keyword1_relevance_score + query_keyword2_relevance_score
          )
        end
      end
    end
  end

  context ".class methods" do
    context ".all" do
      let!(:page2) { described_class.new("P Hello World Web!!") }

      it "should return all pages instances created till now" do
        expect(described_class.all).to match_array([page, page2])
      end

      it "shouldn't miss any pages which is already created till now" do
        expect(described_class.all).not_to match_array([page2])
      end
    end

    context ".new" do
      it "should create only valid query instance" do
        expect { described_class.new("P Hello World") }.not_to raise_error
      end

      it "shouldn't create invalid query instance" do
        expect { described_class.new("Q Hello World") }.to raise_error("Couldn't create page instance")
      end
    end
  end
end
