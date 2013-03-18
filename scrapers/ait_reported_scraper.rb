require 'capybara'
require 'capybara/webkit'
require 'capybara/dsl'
require 'nokogiri'
require 'csv'

Capybara.default_driver = :webkit
Capybara.app_host = 'http://www.ait.gov.uk'


class AitReportedScraper
  include Capybara::DSL

  def visit_all_pages
    @index_session = Capybara::Session.new(:webkit)
    @index_session.visit "/Public/SearchReported.aspx"
    @index_session.click_link("Most recent determinations")
    details_locations_from_html(@index_session.html)
  
    80.times do |i|
      @index_session.find('a#pager1', :text => (i+2).to_s).click
      p "scanning page #{i+2}"
      details_locations_from_html(@index_session.html)
    end
  end
  
  def details_locations_from_html(html)
    html_doc = Nokogiri::HTML(html)
    html_doc.css("table tbody tr").collect do |row|
      visit_detail_page(row.css("td").last.css("a").attr('href').value)
    end
  end

  def visit_detail_page(url)
    @details_session ||= Capybara::Session.new(:webkit)
    old_details_path = "/Public/#{url}"
    old_details_url = "http://www.ait.gov.uk" + old_details_path
    @details_session.visit old_details_path
    html_doc = Nokogiri::HTML(@details_session.html)
    values = html_doc.css("tr").collect {|tr| tr.css("td").last}
    cleaned_values = values.collect {|x| x.content.strip}

    unless decision = Decision.find_by_old_details_url(old_details_url)
      decision = Decision.new(:old_details_url => old_details_url)
      decision.tribunal_id = 1
      decision.reportable = true
      decision.created_at = cleaned_values[0]
      decision.updated_at = cleaned_values[1]
      decision.promulgated_on = cleaned_values[2]
      decision.starred = cleaned_values[3] == "Yes"
      decision.panel = cleaned_values[4] == "Yes"
      decision.country_guideline = cleaned_values[5] == "Yes"
      decision.judges = values[6].css("span").children.collect {|x| x.content}.delete_if {|x| x.blank?}
      decision.categories = cleaned_values[7]
      decision.appeal_number = cleaned_values[8]
      decision.country = cleaned_values[9]
      decision.claiments = cleaned_values[10]
      decision.keywords = cleaned_values[11].split("; ")
      decision.case_notes = cleaned_values[12]
      decision.original_filename = cleaned_values[13]
      decision.url = "http://www.ait.gov.uk/Public/" + values.last.css("a").attr('href').value
      decision.save!
      p decision
    else
      p "Skipping #{old_details_url}"
    end
  end
end