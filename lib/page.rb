require_relative "keyword"

class Page
  attr_accessor :name, :content, :keywords

  @@count = 0
  @@all = []

  MAX_WEIGHT = 1000

  def initialize(data)
    @@count += 1
    @name, @content = "#{data[0]}#{@@count}", data[2..-1]
    weight = MAX_WEIGHT
    @keywords = @content.split(" ").map do |word|
      keyword = Keyword.new(word, weight)
      weight -= 1
      keyword
    end

    @@all << self
  end

  def self.all
    @@all
  end

  def relevance_score(query_word)
    keywords.select { |keyword| keyword.same? query_word }.map { |keyword| keyword.weight * query_word.weight }.sum
  end

  def score(query)
    query.keywords.map { |query_word| relevance_score(query_word) }.sum
  end
end
