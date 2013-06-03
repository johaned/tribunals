require 'capybara'
require 'capybara/webkit'
require 'capybara/dsl'
require 'nokogiri'

Capybara.default_driver = :webkit
Capybara.app_host = 'http://www.ait.gov.uk'


class AitUnreportedScraper
  include Capybara::DSL

  def visit_all_pages
    session = Capybara::Session.new(:webkit)
    session.visit "/Public/unreportedResults.aspx"
    session.click_link("Search again")
    session.click_button("Search")
    doc_locations_from_html(session.html)
  
    begin
      (2..Float::INFINITY).each do |i|
        session.find('a#pager1', :text => i.to_s).click
        p "scanning page #{i}"
        doc_locations_from_html(session.html)
      end
    rescue Capybara::ElementNotFound
    end
    p "scanned all pages"
  end
  
  def doc_locations_from_html(html)
    html_doc = Nokogiri::HTML(html)
    html_doc.css("table tbody tr").collect do |row|
      document_location = row.css("td a").attr('href').value
      date = row.css("td").last.text.gsub(/\s/, "")
      url = "http://www.ait.gov.uk/Public/"+document_location
      unless Decision.exists?(url: url)
        p Decision.create!(:url => url, :promulgated_on => date, :tribunal_id => 1, :reported => false)
      end
    end
  end
end
