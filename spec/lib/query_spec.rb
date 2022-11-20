require "spec_helper"
require "./lib/keyword"
require "./lib/page"
require "./lib/query"

RSpec.describe Query do
  let!(:query) { described_class.new("Q Hello World Web") }

  after(:each) do
    described_class.class_variable_set :@@all, []
    described_class.class_variable_set :@@count, 0
  end

  context "#attr_accessor" do
    it "should respond to #name" do
      expect(query).to respond_to(:name)
    end

    it "should respond to #name=" do
      expect(query).to respond_to(:name=)
    end

    it "should respond to #keywords" do
      expect(query).to respond_to(:keywords)
    end

    it "should respond to #keywords=" do
      expect(query).to respond_to(:keywords=)
    end
  end

  context "#instance methods" do
    context "#private methods" do
      context "#parse_keywords" do
        let(:parsed_result)         { query.send(:parse_keywords, "Hello World Web") }
        let(:parsed_keword_names)   { parsed_result.map(&:name) }
        let(:parsed_keword_weights) { parsed_result.map(&:weight) }

        it "should return parsed keywords array" do
          expect(parsed_keword_names).to match_array(["Hello", "World", "Web"])
          expect(parsed_keword_weights).to match_array([Query::MAX_WEIGHT, Query::MAX_WEIGHT - 1, Query::MAX_WEIGHT - 2])
        end
      end
    end

    context "#public methods" do
      context "#search" do
        let!(:page1) { Page.new("P Hello World") }
        let!(:page2) { Page.new("P Hello India") }
        let!(:page3) { Page.new("P Mr. India") }

        it "should return corresponding pages in which query's keywords exists" do
          expect(query.search([page1, page2, page3])).to eq("#{query.name}: #{page1.name} #{page2.name}")
        end

        it "shouldn't return any pages in which query's keywords doesn't exist" do
          expect(query.search([page1, page2, page3])).not_to include(page3.name)
        end
      end
    end
  end

  context ".class methods" do
    context ".all" do
      let!(:query2) { described_class.new("Q Hello World Web!!") }

      it "shouldn't miss any queries which is already created till now" do
        expect(described_class.all).not_to match_array([query2])
      end

      it "should return all queries instances created till now" do
        expect(described_class.all).to match_array([query, query2])
      end
    end

    context ".new" do
      it "should create only valid query instance" do
        expect { described_class.new("Q Hello World") }.not_to raise_error
      end

      it "shouldn't create invalid query instance" do
        expect { described_class.new("P Hello World") }.to raise_error("Couldn't create query instance")
      end
    end

    context ".search_all" do
      let!(:page1)         { Page.new("P Hello World") }
      let!(:page2)         { Page.new("P Hello India") }
      let!(:page3)         { Page.new("P Mr. India") }
      let!(:query2)        { described_class.new("Q india") }
      let!(:query3)        { described_class.new("Q Search") }
      let!(:query_result1) { "#{query.name}: #{page1.name} #{page2.name}" }
      let!(:query_result2) { "#{query2.name}: #{page2.name} #{page3.name}" }
      let!(:query_result3) { "#{query3.name}: " }

      it "should return corresponding pages in which query's keywords exists" do
        expect(described_class.search_all([page1, page2, page3])).to match_array([
          query_result1,
          query_result2,
          query_result3
        ])
      end
    end
  end
end
