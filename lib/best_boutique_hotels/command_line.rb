require_relative "../best_boutique_hotels.rb"

class CommandLineInterface
  BASE_URL = "http://www.boutiquehotelawards.com/boutique-hotels/latest-winners/"

  @current_category = ""
  @current_category_index = ""

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
    if c_index.to_i.between?(1, Category.all.size)
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
    if h_index.to_i.between?(1, @current_category.hotels.size)
      view_hotel(@current_category.hotels[h_index.to_i-1])
    else
      puts "Oops, that's not a valid hotel.".colorize(:red)
      hotel_navigation
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
      i == 0 ? (puts "  Additional Details:\n".colorize(:blue)  + wrap("    #{note}")) : (puts wrap("    #{note}"))
    end
    continue?
  end

  def continue?
    puts ""
    puts "Would you like to continue? (Y/N)".white.on_blue
    answer = gets.strip.upcase
    if answer == "Y"
      repeat_navigation
    elsif
      answer == "N"
      puts "Bye!"
      exit
    else
      "I didn't understand you."
      continue?
    end
  end

  def repeat_navigation
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
    end
  end

  def wrap(string, line_width=78)
    return string if string.length <= line_width
    if string[0...line_width].index(" ") != nil
      space_index = (line_width-1) - string[0...line_width].reverse.index(" ")
      string[0...space_index] + "\n     " + wrap(string[space_index+1..-1], line_width-5)
    elsif string[line_width] == " "
      string[0...line_width] + "\n     " + wrap(string[line_width+1..-1], line_width-5)
    else
      string[0...line_width] + "\n     " + wrap(string[line_width..-1], line_width-5)
    end
  end
