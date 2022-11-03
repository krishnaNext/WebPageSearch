require_relative "keyword"

class Query
  attr_accessor :name, :content, :keywords

  MAX_WEIGHT = 1000

  @@count = 0
  @@all = []

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

  def relevance_score(page)
    keywords.map { |keyword| page.relevance_score(keyword) }.sum
  end

  def self.all
    @@all
  end
end
