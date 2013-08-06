namespace :maintenance do
  task :assign_ncn => [:environment] do
    ActiveRecord::Base.connection.execute("UPDATE decisions SET ncn = appeal_number WHERE reported")
  end

  task :assign_appeal_number => [:environment] do
    Decision.where("reported = 'f' AND doc_file IS NOT NULL AND appeal_number IS NULL").find_each do |d|
      begin
        d.appeal_number = UkitUtils.appeal_numbers_from_filename(d.doc_file.to_s).map do |an|
          UkitUtils.format_appeal_number(an)
        end.join(', ')
        d.save!
      rescue
        puts d.inspect
        next
      end
    end
  end
end
