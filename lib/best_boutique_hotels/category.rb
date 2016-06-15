class Category

  attr_accessor :name, :url, :hotels

  @@all = []

  def initialize(name, url)
    @name = name
    @url = url
    @hotels = []
  end

  def add_hotels(hotels_array)
    hotels_array.each do |hotel|
      unless @hotels.include?(hotel)
        @hotels << hotel
        hotel.category = self
      end
    end
  end

  def self.create_from_collection(categories_array)
    categories_array.each_with_index do |category|
      self.all << Category.new(category[:category_name], category[:category_url])
    end
  end

  def self.all
    @@all
  end

end
