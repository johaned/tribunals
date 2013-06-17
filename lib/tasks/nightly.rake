namespace :nightly do
  task :import => ['import:import_ait_unreported',
                   'import:import_ait_reported',
                   'import:fetch_word_documents',
                   'import:process_word_documents'] do
  end
end
