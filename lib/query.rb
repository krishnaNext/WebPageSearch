require_relative "keyword"

class Query
  attr_accessor :name, :keywords

  @@count = 0
  @@all = []

  MAX_WEIGHT = 1000

  def initialize(data)
    key = data[0]
    raise "Couldn't create query instance" if key.downcase != "q"

    content = data[2..-1].strip
    @keywords = parse_keywords(content)
    @@count += 1
    @name = "#{key.upcase}#{@@count}"
    @@all << self
  end

  def search(pages)
    resulted_pages = pages.select { |page| page.score(self).positive? }
                          .sort_by { |page| -page.score(self) }[0..4]

    page_names = resulted_pages.map { |page| page.name }
                               .join(" ")

    "#{name}: #{page_names}"
  end

  def self.all
    @@all
  end

  def self.search_all(pages)
    all.map do |query|
      query.search(pages)
    end
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
end
