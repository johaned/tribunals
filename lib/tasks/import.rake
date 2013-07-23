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

  task :make_html_from_text => :environment do
    Decision.where("html IS NOT NULL").find_each do |decision|
      decision.set_html_from_text
      decision.save!
    end
  end

  task :fetch_word_documents => :environment do
    Decision.where("url IS NOT NULL AND doc_file IS NULL").find_each do |d|
      d.fetch_doc_file
    end
  end

  task :process_word_documents => :environment do
    Decision.where("doc_file IS NOT NULL AND pdf_file IS NULL").find_each do |d|
      p d.url
      p d.process_doc
    end
  end
end
