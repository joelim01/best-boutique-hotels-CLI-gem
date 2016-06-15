class Hotel

  attr_accessor :hotel_name, :category, :location, :hotel_website, :number_of_rooms, :price, :notes, :headline, :hotel_url

  @@all = []

  def initialize(hotel_details)
    hotel_details.each {|key, value| self.send(("#{key}="), value)}
    self.class.all << self
  end

  def self.create_from_collection(hotels_array)
    hotels_array.each {|hotel| Hotel.new(hotel)}
  end

  def add_hotel_attributes(attributes_hash)
    attributes_hash.each {|key, value| self.send(("#{key}="), value)}
  end

  def self.all
    @@all
  end
end
