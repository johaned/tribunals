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
      d.update_attributes(:judges => d.judges.map(&:strip)) unless d.judges.empty?
    end
  end
end
