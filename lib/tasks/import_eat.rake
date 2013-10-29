require 'eat_importer'

namespace :import do
  namespace :eat do

    desc "run all the tasks for the import:eat namespace"
    task :all => [:judgments, :js1, :js2, :judgment_jurisdiction]

    desc "import EAT judgments"
    task :judgments => :environment do
      EATImporter.new('data/eat').import_judgments
    end

    desc "import EAT jurisdiction_level1"
    task :js1 => :environment do
      EATImporter.new('data/eat').import_js1
    end

    desc "import EAT jurisdiction_level2"
    task :js2 => :environment do
      EATImporter.new('data/eat').import_js2
    end

    desc "import EAT judment_jurisdictions"
    task :judgment_jurisdiction => :environment do
      EATImporter.new('data/eat').import_category_decision
    end

  end
end
