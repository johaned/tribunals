require 'csv_importer'

namespace :import do
  task :all => [:csv]

  task :csv => :environment do
    CSVImporter.new('data').run
  end
end
