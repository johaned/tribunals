namespace :nightly do
  task :scrape => [:environment, 'import:import_ait_unreported', 'import:import_ait_reported']
  task :fetch_and_process => [:environment] do
    Decision.where('url IS NOT NULL AND doc_file IS NULL').find_each do |d|
      d.fetch_doc_file
      p d.url
      d.process_doc
    end
  end
  task :import => [:scrape, :fetch_and_process]
end
