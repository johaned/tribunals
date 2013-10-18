require 'csv_importer'

namespace :import do
  task :all => [:csv]

  task :csv => :environment do
    CSVImporter.new('data').run
  end

  namespace :aac do
    task :decisions => :environment do
      CSVImporter.new('data/aac').import_decisions
    end

    task :decision_categories => :environment do
      CSVImporter.new('data/aac').import_categories
    end

    task :decision_subcategories => :environment do
      CSVImporter.new('data/aac').import_subcategories
    end

    task :judges => :environment do
      CSVImporter.new('data/aac').import_judges
    end

    task :decisions_judges_mapping => :environment do
      CSVImporter.new('data/aac').import_decisions_judges_mapping
    end
  end
end
