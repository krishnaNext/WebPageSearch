require_relative "page"
require_relative "query"

class WebSearch
  attr_accessor :pages, :queries

  def initialize(input_file, output_file)
    @pages = []
    @queries = []
    read_input(input_file)
    export_result(output_file)
  end

  private

  def read_input(file)
    file = File.open(file, "r")
    file.each_line { |line| generate_page_and_query(line.strip) }
    file.close
  end

  def generate_page_and_query(data)
    case data[0]
    when "P"
      @pages << Page.new(data)
    when "Q"
      @queries << Query.new(data)
    end
  end

  def search
    Query.all.map do |query|
      pages = Page.all
                  .select { |page| page.score(query).positive? }
                  .sort_by { |page| -page.score(query) }[0..4]

      page_names = pages.map { |page| page.name }.join(" ")
      p "#{query.name}: #{page_names}"
    end
  end

  def export_result(file)
    File.open(file, "w") do |file|
      search.each { |content| file.write(content + "\r\n") }
    end
  end
end
