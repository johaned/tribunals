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

  task :import_word_docs_from_urls => :environment do
    Decision.find_each do |decision|
      if decision.url.present? && decision.doc_file.blank?
        decision.fetch_doc_file
        p decision.process_doc
        decision.save!
      end
    end
  end
end