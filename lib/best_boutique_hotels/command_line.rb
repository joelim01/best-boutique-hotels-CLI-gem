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
  @current_category_index = ""

  def run
    make_categories
    make_hotels
    add_details_to_hotels
    binding.pry
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
    puts "www.boutiquehotelawards.com".white.on_blue.underline
    puts "A list of the top boutique hotels in the world in the following categories:".white.on_blue.underline
    puts ""
    Category.all.each_with_index do |c, i|
      puts "#{i+1}. #{c.name}".colorize(:blue)
    end
    category_navigation
  end

  def category_navigation
    puts ""
    puts "Choose a category to view hotels.".white.on_blue.underline
    c_index = gets.strip
    if c_index.to_i.between?(1, Category.all.size+1)
      @current_category_index = c_index.to_i-1
      list_hotels(c_index.to_i-1)
    else
      puts "Yikes, try a valid category.".colorize(:red)
      category_navigation
    end
  end

  def list_hotels(c_index)
    @current_category = Category.all[c_index]
    puts "#{@current_category.name} hotels:".white.on_blue.underline
    puts ""
    @current_category.hotels.each_with_index do |h, i|
      puts "#{i+1}. #{h.hotel_name}".colorize(:blue)
    end
    hotel_navigation
  end

  def hotel_navigation
    puts ""
    puts "Choose a hotel to view details.".white.on_blue
    h_index = gets.strip
    if h_index.to_i.between?(1, @current_category.hotels.size+1)
      view_hotel(@current_category.hotels[h_index.to_i-1])
    else
      puts "Oops, that's not a valid hotel.".colorize(:red)
      category_navigation
    end
  end

  def view_hotel(hotel)
    puts ""
    puts "#{hotel.hotel_name.upcase}".white.on_blue.underline
    puts wrap("#{hotel.headline}".colorize(:light_blue))
    puts " .     -     -     -     . "
    puts wrap("  Location: ".colorize(:blue) + "#{hotel.location}")
    puts wrap("  Category: ".colorize(:blue) + "#{hotel.category.name}")
    puts wrap("  Website: ".colorize(:blue) + "#{hotel.hotel_website}")
    puts wrap("  Number of Rooms: ".colorize(:blue) + "#{hotel.number_of_rooms}")
    puts wrap("  Price: ".colorize(:blue) + "#{hotel.price}")
    hotel.notes.each_with_index do |note, i|
      i == 0 ? (puts wrap("  Additional Details:\n".colorize(:blue) + "    #{note}")) : (puts wrap("    #{note}"))
    end
    repeat_navigation
  end

  def repeat_navigation
    puts ""
    puts "Would you like to continue? (Y/N)".white.on_blue
    answer = gets.strip.upcase
    if answer == "Y"
      puts wrap("Would you like to go (back) to the hotel listings for #{@current_category.name} or go to the (categories) page?")
      answer = gets.strip.downcase
        if answer == "back"
          list_hotels(@current_category_index)
        elsif
          answer == "categories"
          @current_category = ""
          @current_category_index = 0
          begin_navigation
        else
          repeat_navigation
        end
    elsif
      answer == "N"
      exit
    else
      repeat_navigation
    end
  end

  def wrap(string, line_width=70)
    return string if string.length <= line_width
    if string[0...line_width].index(" ") != nil
      space_index = (line_width-1) - string[0...line_width].reverse.index(" ")
      string[0...space_index] + "\n        " + wrap(string[space_index+1..-1], line_width-8)
    elsif string[line_width] == " "
      string[0...line_width] + "\n        " + wrap(string[line_width+1..-1], line_width-8)
    else
      string[0...line_width] + "\n        " + wrap(string[line_width..-1], line_width-8)
    end
  end

end



command = CommandLineInterface.new
command.run
