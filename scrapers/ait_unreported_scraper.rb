require 'capybara'
require 'capybara/webkit'
require 'capybara/dsl'
require 'nokogiri'

Capybara.default_driver = :webkit
Capybara.app_host = 'http://www.ait.gov.uk'


class AitUnreportedScraper
  include Capybara::DSL

  def initialize(stdout=STDOUT)
    @stdout = stdout
  end

  def visit_all_pages(page_range=2..Float::INFINITY)
    session = Capybara::Session.new(:webkit)
    session.visit "/Public/unreportedResults.aspx"
    session.click_link("Search again")
    session.click_button("Search")
    doc_locations_from_html(session.html)

    begin
      page_range.each do |i|
        session.find('a#pager1', :text => i.to_s).click
        p "scanning page #{i}"
        doc_locations_from_html(session.html)
      end
    rescue Capybara::ElementNotFound
      p "couldn't find page"
    end
    p "scanned all pages"
  end
  
  def doc_locations_from_html(html)
    html_doc = Nokogiri::HTML(html)
    html_doc.css("table tbody tr").each do |row|
      document_location = row.css("td a").attr('href').value
      date = row.css("td").last.text.gsub(/\s/, "")
      url = "http://www.ait.gov.uk/Public/"+document_location
      unless Decision.exists?(url: url)
        d = Decision.new(:url => url, :promulgated_on => date, :tribunal_id => 1, :reported => false)
        p d.inspect
        d.save(validate: false)
      end
    end
  end

  def p(string)
    @stdout.puts(string)
  end
end
