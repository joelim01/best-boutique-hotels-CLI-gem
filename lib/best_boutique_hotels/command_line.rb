require_relative "../best_boutique_hotels/scraper.rb"
require_relative "../best_boutique_hotels/hotel.rb"
require_relative "../best_boutique_hotels/category.rb"
require 'nokogiri'
require 'colorize'
require 'pry'
require 'ruby-progressbar'

class CommandLineInterface
  BASE_URL = "http://www.boutiquehotelawards.com/boutique-hotels/latest-winners/"

  @current_category = ""

  def run
    make_categories
    make_hotels
    add_details_to_hotels
    begin_navigation
  end

  def make_categories
    categories_array = Scraper.scrape_index_page(BASE_URL)
    Category.create_from_collection(categories_array)
    puts "Getting Categories...".white.on_blue.underline
  end

  def make_hotels
    hotels_array = []
    Category.all.each do |category|
      hotels_array = Scraper.scrape_category_page(category.url)
      category_hotels = Hotel.create_from_collection(hotels_array)
      category.add_hotels(category_hotels)
      puts "#{category.name} created.".colorize(:blue)
    end
  end


  def add_details_to_hotels
    puts "Getting Hotel details...".white.on_blue.underline
    progressbar = ProgressBar.create(:total=>Hotel.all.size)
    Hotel.all.each_with_index do |hotel, index|
      progressbar.increment
      attributes = Scraper.scrape_hotel_page(hotel.hotel_url)
      hotel.add_hotel_attributes(attributes)
    end
  end

  def begin_navigation
    puts "www.boutiquehotelawards.com"
    puts "List of the top boutique hotels in the world in the following categories:"
    puts ""
    Category.all.each_with_index do |c, i|
      puts "#{i+1}. #{c.name}."
    end
    category_navigation
  end

  def category_navigation
    puts ""
    puts "Choose a category to view hotels."
    c_index = gets.strip
    if c_index.to_i.between?(1, Category.all.size+1)
      list_hotels(c_index.to_i-1)
    else
      category_navigation
    end
  end

  def list_hotels(c_index)
    @current_category = Category.all[c_index]
    puts "#{@current_category.name} hotels."
    puts ""
    @current_category.hotels.each_with_index do |h, i|
      puts "#{i+1}. #{h.hotel_name}."
    end
    hotel_navigation
  end

  def hotel_navigation
    puts ""
    puts "Choose a hotel to view details."
    h_index = gets.strip
    if h_index.to_i.between?(1, @current_category.hotels.size+1)
      binding.pry
      @current_category.hotels[h_index.to_i-1].each do |k,v|
        puts "#{k}: #{v}."
      end
    else
      category_navigation
    end
  end
end



command = CommandLineInterface.new
command.run
