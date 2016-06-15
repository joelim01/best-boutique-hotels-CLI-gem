require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    categories_array = []
    hotels_array = []

    doc = Nokogiri::HTML(open(index_url))
    category_links = doc.css('div.overlay-content-cat a').collect {|el| el['href'] }
    category_names = doc.css('div.overlay-content-cat a').collect {|el| el.text }

    category_names.each_with_index do |category, index|
      categories_array << Hash[category_name: category, category_url: category_links[index]]
    end

    categories_array

  end

  def self.scrape_category_page(category_url)

    hotel_array = []
    doc = Nokogiri::HTML(open(category_url))
    hotel_links = doc.css('h3.title-hotel-row a').collect {|el| el['href'].strip }
    hotel_names = doc.css('h3.title-hotel-row a').collect {|el| el.text.strip }
    category = doc.css('h2.location_name').text.strip
    hotel_names.each_with_index do |hotel, index|
      hotel_array << Hash[hotel_name: hotel, hotel_url: hotel_links[index], category: category]
    end

    hotel_array

  end

  def self.scrape_hotel_page(hotel_url)

    hotel_details = []

    location = ""
    hotel_website = ""
    headline = ""
    notes = []
    price = nil
    number_of_rooms = nil

    doc = Nokogiri::HTML(open(hotel_url))

    location = doc.css('div.address-section div li')[0].text unless doc.css('div.address-section div li')[0] == nil
    hotel_website = doc.css('div.action-link-hotel a')[1]['href'] unless (doc.css('div.action-link-hotel a')[1] == nil || doc.css('div.action-link-hotel a')[1]['href'].include?('boutiquehotelawards'))
    headline = doc.css('div.tag-line').text unless doc.css('div.tag-line') == nil
    notes = doc.css('div.hotel-info ul')[0] unless doc.css('div.hotel-info ul')[0] == nil
    notes = notes.css('li').collect {|el| el.text} unless notes == []
    number_of_rooms = notes[0] unless notes == nil
    notes.shift unless notes == nil
    price = notes.detect {|text| (text.include?("$") || text.include?("USD") || text.include?("EUR"))} unless notes == nil
    notes.reject!{ |item| item == price} unless notes == nil

    hotel_details = Hash[location: location, hotel_website: hotel_website, number_of_rooms: number_of_rooms, price: price, notes: notes, headline: headline]
    hotel_details.reject!{|k , v| (v == nil || v == "" || v == [])}
    hotel_details
  end

end


# Scraper.scrape_index_page('http://www.boutiquehotelawards.com/boutique-hotels/latest-winners/')

  #  students_array = []
  #
  #  names_array.each_with_index do |name, index|
  #    students_array << Hash[name: name, location: location_array[index], profile_url: "http://159.203.117.55:4187/fixtures/student-site/"+profile_url_array[index]]
  #  end
  #  students_array
  # end
  #
  # def self.scrape_profile_page(profile_url)
  #
  #   doc = Nokogiri::HTML(open(profile_url))
  #   twitter = ""
  #   linkedin = ""
  #   github = ""
  #   blog = ""
  #   profile_quote = doc.css('div.profile-quote').text
  #   bio = doc.css('div.description-holder p').text
  #
  #   social = doc.css('div.social-icon-container a').collect {|el| el['href'] }
  #   social.each do |link|
  #    if link.include?("twitter")
  #      twitter = link
  #    elsif link.include?("linkedin")
  #      linkedin = link
  #    elsif link.include?("github")
  #      github = link
  #    else
  #      blog = link
  #    end
  #   end
  #   student = Hash[twitter: twitter, linkedin: linkedin, blog: blog, github: github, profile_quote: profile_quote, bio: bio]
  #   student.reject!{|k,v| v == ""}
  #   student
  #  end
  #
