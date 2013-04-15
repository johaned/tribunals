namespace :import do
  task :import_ait_unreported => :environment do
    p AitUnreportedScraper.new.visit_all_pages
  end

  task :import_ait_reported => :environment do
    p AitReportedScraper.new.visit_all_pages
  end

  task :extract_appeal_numbers => :environment do
    Decision.where("appeal_number IS NULL").find_each do |decision|
      if decision.text
        decision.extract_appeal_number
        decision.save
      end
    end
  end

  task :import_word_docs_from_urls => :environment do
    Decision.where("url IS NOT NULL").where("doc_file IS NULL").find_each do |decision|
      decision.fetch_doc_file
      p decision.process_doc
      decision.save!
    end
  end
end