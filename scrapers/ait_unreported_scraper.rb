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
  
    2030.times do |i|
      session.find('a#pager1', :text => (i+2).to_s).click
      p "scanning page #{i+2}"
      doc_locations_from_html(session.html)
    end
  end
  
  def doc_locations_from_html(html)
    html_doc = Nokogiri::HTML(html)
    html_doc.css("table tbody tr").collect do |row|
      document_location = row.css("td a").attr('href').value
      date = row.css("td").last.text.gsub(/\s/, "")
      p Decision.create!(:url => "http://www.ait.gov.uk/Public/"+document_location, :promulgated_on => date, :tribunal_id => 1, :reported => false)
    end
  end
end
