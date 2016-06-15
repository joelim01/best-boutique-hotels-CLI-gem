class Category

  attr_accessor :name, :url

  @@all = []

  def initialize(name, url)
    @name = name
    @url = url
  end

  def add_hotels(hotels_array)
    hotels_array.each {|hotel| self.all << hotel unless self.all.include?(hotel)}
  end

  def self.create_from_collection(categories_array)
    categories_array.each_with_index do |category|
      Category.new(category[:category_name], category[:category_url])
    end
  end

  def self.all
    @@all
  end

end
