namespace :nightly do
  task :import => ['import:import_ait_unreported',
                   'import:import_ait_reported',
                   'import:import_word_docs_from_urls'] do
  end
end
