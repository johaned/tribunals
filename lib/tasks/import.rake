namespace :import do
  task :import_ait_unreported => :environment do
    p AitUnreportedScraper.new.visit_all_pages
  end

  task :import_ait_reported => :environment do
    p AitReportedScraper.new.visit_all_pages
  end

  task :extract_appeal_numbers => :environment do
    Decision.find_each do |decision|
      decision.extract_appeal_number
      decision.save
    end
  end
end