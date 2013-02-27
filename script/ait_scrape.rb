require 'capybara'
require 'capybara/webkit'
require 'capybara/dsl'
require 'nokogiri'
require 'csv'

Capybara.default_driver = :webkit
Capybara.app_host = 'http://www.ait.gov.uk'


class AitScraper
  include Capybara::DSL

  def visit_all_pages
    session = Capybara::Session.new(:webkit)
    session.visit "/Public/unreportedResults.aspx"
    session.click_link("Search again")
    session.click_button("Search")
    CSV.open(File.join(File.dirname(__FILE__), "output.csv"), "wb") do |csv|
      doc_locations_from_html(session.html).each do |line|
        csv << line
      end
    
      2030.times do |i|
        session.find('a#pager1', :text => (i+2).to_s).click
        p "scanning page #{i+2}"
        doc_locations_from_html(session.html).each do |line|
          csv << line
        end
      end
    end
  end
  
  def doc_locations_from_html(html)
    html_doc = Nokogiri::HTML(html)
    html_doc.css("table tbody tr").collect do |row|
      document_location = row.css("td a").attr('href').value
      date = row.css("td").last.text.gsub(/\s/, "")
      [document_location, date]
    end
  end
end

p AitScraper.new.visit_all_pages
