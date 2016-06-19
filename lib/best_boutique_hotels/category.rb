class Category

  attr_accessor :name, :url, :hotels

  @@all = []

  def initialize(name, url)
    @name = name
    @url = url
    @hotels = []
  end

  def self.create_from_collection(categories_array)
    categories_array.each do |category|
      self.all << Category.new(category[:category_name], category[:category_url])
    end
  end

  def self.all
    @@all
  end

end
