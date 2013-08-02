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
  
    begin
      (2..Float::INFINITY).each do |i|
        @index_session.find('a#pager1', :text => i.to_s).click
        p "scanning page #{i}"
        details_locations_from_html(@index_session.html)
      end
    rescue Capybara::ElementNotFound
    end
    p "scanned all pages"
  end
  
  def details_locations_from_html(html)
    html_doc = Nokogiri::HTML(html)
    html_doc.css("table tbody tr").collect do |row|
      url = row.css("td").last.css("a").attr('href').value
      case_name = row.css("td")[1].content.strip
      promulgated_on = row.css("td")[4].content
      visit_detail_page(url, case_name, promulgated_on)
    end
  end

  def visit_detail_page(url, case_name, promulgated_on)
    @details_session ||= Capybara::Session.new(:webkit)
    old_details_path = "/Public/#{url}"
    old_details_url = "http://www.ait.gov.uk" + old_details_path
    @details_session.visit old_details_path
    html_doc = Nokogiri::HTML(@details_session.html)
    values = html_doc.css("tr").collect {|tr| tr.css("td").last}
    cleaned_values = values.collect {|x| x.content.strip}
    url = "http://www.ait.gov.uk/Public/" + values.last.css("a").attr('href').value

    unless Decision.exists?(url: url) || Decision.exists?(old_details_url: old_details_url)
      decision = Decision.new(:old_details_url => old_details_url)
      decision.tribunal_id = 1
      decision.reported = true
      decision.case_name = case_name
      decision.promulgated_on = promulgated_on
      decision.created_at = cleaned_values[0]
      decision.updated_at = cleaned_values[1]
      decision.promulgated_on = cleaned_values[2]
      decision.starred = cleaned_values[3] == "Yes"
      decision.country_guideline = cleaned_values[5] == "Yes"
      decision.judges = values[6].css("span").children.collect {|x| x.content}.delete_if {|x| x.blank?}
      decision.categories = cleaned_values[7]
      decision.appeal_number = cleaned_values[8]
      decision.country = cleaned_values[9]
      decision.claimant = cleaned_values[10]
      decision.keywords = cleaned_values[11].split("; ")
      decision.case_notes = cleaned_values[12]
      decision.original_filename = cleaned_values[13]
      decision.url = url
      decision.save!
      p decision
    else
      p "Skipping #{old_details_url}"
    end
  end
end
