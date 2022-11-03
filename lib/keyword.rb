class Keyword
  attr_accessor :name, :weight

  def initialize(name, weight)
    @name = name
    @weight = weight
  end

  def same?(keyword)
    name.to_s.downcase == keyword.name.to_s.downcase
  end
end
