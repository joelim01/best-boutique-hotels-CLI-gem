require_relative "../best_boutique_hotels/scraper.rb"
require_relative "../best_boutique_hotels/hotel.rb"
require_relative "../best_boutique_hotels/category.rb"
require 'nokogiri'
require 'colorize'
require 'pry'

class CommandLineInterface
  BASE_URL = "http://www.boutiquehotelawards.com/boutique-hotels/latest-winners/"

  def run
    make_categories
    make_hotels
    add_details_to_hotels
    begin_navigation
  end

  def make_categories
    categories_array = Scraper.scrape_index_page(BASE_URL)
    Category.create_from_collection(categories_array)
  end

  def make_hotels
    hotels_array = []
    Category.all.each do |category|
      hotels_array = Scraper.scrape_category_page(category.url)
      category_hotels = Hotel.create_from_collection(hotels_array)
      category.add_hotels(category_hotels)
    end
  end


  def add_details_to_hotels
    Hotel.all.each do |hotel|
      attributes = Scraper.scrape_hotel_page(hotel.hotel_url)
      hotel.add_hotel_attributes(attributes)
    end
    binding.pry
  end

end

command = CommandLineInterface.new
command.run
