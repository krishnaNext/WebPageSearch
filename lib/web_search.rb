require_relative "page"
require_relative "query"

class WebSearch
  attr_accessor :pages, :queries

  def initialize
    @pages = []
    @queries = []
  end

  def read_input(file)
    file = File.open(file, "r")
    file.each_line { |line| parse_input(line.strip) }
    file.close
  end

  def export_output(file)
    pages = Page.all
    result = Query.search_all(pages)
    file = File.open(file, "w")
    result.each { |content| file.write(content + "\r\n") }
    file.close
  end

  private

  def parse_input(line)
    case line[0].downcase
    when "p"
      @pages << Page.new(line)
    when "q"
      @queries << Query.new(line)
    end
  end
end
