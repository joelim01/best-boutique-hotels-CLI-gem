class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    doc.css('div.overlay-content-cat a').collect do |category|
      category_attribues = {
        :category_url => category['href'],
        :category_name => category.text.strip
      }
    end
  end

  def self.scrape_category_page(category_url)
    doc = Nokogiri::HTML(open(category_url))
    hotel_array = doc.css('h3.title-hotel-row a').collect do |hotel|
      hotel_attributes = {
        :hotel_url => hotel['href'],
        :hotel_name => hotel.text.strip
      }
    end
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
