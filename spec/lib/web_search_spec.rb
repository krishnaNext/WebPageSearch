require "spec_helper"
require "./lib/keyword"
require "./lib/page"
require "./lib/query"
require "./lib/web_search"

RSpec.describe WebSearch do
  let(:input_file) { "spec/fixtures/input.txt" }
  let(:output_file) { "spec/fixtures/output.txt" }
  let(:web_search) { described_class.new }

  after(:each) do
    Page.class_variable_set :@@all, []
    Page.class_variable_set :@@count, 0
    Query.class_variable_set :@@all, []
    Query.class_variable_set :@@count, 0
  end

  context "#attr_accessor" do
    it "should respond to #pages" do
      expect(web_search).to respond_to(:pages)
    end

    it "should respond to #pages=" do
      expect(web_search).to respond_to(:pages=)
    end

    it "should respond to #queries" do
      expect(web_search).to respond_to(:queries)
    end

    it "should respond to #queries=" do
      expect(web_search).to respond_to(:queries=)
    end
  end

  context "#instance methods" do
    context "#read_input" do
      it "should read the page inputs from given file" do
        web_search.read_input(input_file)
        expect(web_search.pages.size).to eq(6)
      end

      it "should read the query inputs from given file" do
        web_search.read_input(input_file)
        expect(web_search.queries.size).to eq(6)
      end
    end

    context "#export_output" do
      before(:each) do
        web_search.read_input(input_file)
        web_search.export_output(output_file)
        @file = File.open(output_file, "r")
      end

      after(:each) do
        @file.close
      end

      it "should write the searched result output to given file" do
        expect(@file.readlines.size).to eq(6)
      end
    end
  end
end
