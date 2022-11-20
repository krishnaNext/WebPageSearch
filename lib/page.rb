require_relative "keyword"

class Page
  attr_accessor :name, :keywords

  @@count = 0
  @@all = []

  MAX_WEIGHT = 1000

  def initialize(data)
    key = data[0]
    raise "Couldn't create page instance" if key.downcase != "p"

    content = data[2..-1].strip
    @keywords = parse_keywords(content)
    @@count += 1
    @name = "#{key.upcase}#{@@count}"
    @@all << self
  end

  def score(query)
    query.keywords
         .map { |query_keyword| relevance_score(query_keyword) }
         .sum
  end

  def self.all
    @@all
  end

  private

  def parse_keywords(content)
    weight = MAX_WEIGHT

    content.split(" ").map do |word|
      keyword = Keyword.new(word.strip, weight)
      weight -= 1
      keyword
    end
  end

  def relevance_score(query_keyword)
    keywords.select { |keyword| keyword.same? query_keyword }
            .map { |keyword| keyword.weight * query_keyword.weight }
            .sum
  end
end
