namespace :import do
  task :docs_from_csv => :environment do
    require 'open-uri'
    require 'csv'
    CSV.foreach(File.join(Rails.root, "data", "ait.csv")) do |document|
      Decision.create!(:doc_file => open("http://www.ait.gov.uk/Public/"+document[0]), :promulgated_on => document[1].to_date)
    end
  end
end