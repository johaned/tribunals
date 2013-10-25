namespace :maintenance do
  task :assign_ncn => [:environment] do
    ActiveRecord::Base.connection.execute("UPDATE decisions SET ncn = appeal_number WHERE reported")
  end

  task :assign_appeal_number => [:environment] do
    Decision.where("reported = 'f' AND doc_file IS NOT NULL AND appeal_number IS NULL").find_each do |d|
      puts d.try_extracting_appeal_numbers
      d.save
    end
  end

  task :remove_judges_whitespace => :environment do
    Decision.where("judges IS NOT NULL").except(:text, :html).find_each do |d|
      unless d.judges.empty?
        d.judges = d.judges.map {|j| j.strip.squish }
        #Turn off validation while saving because some records have data missing for required fields
        d.save(validate: false)
      end
    end
  end

  namespace :aac do
    task :remove_judges_whitespace => :environment do
      Judge.find_each do |j|
        j.name = j.name.strip.squish
        #Turn off validation while saving because some records have data missing for required fields
        j.save(validate: false)
      end
    end
  end
end
