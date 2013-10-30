require 'csv_importer'

class FTTImporter < CSVImporter
  def import_judgments
    FttDecision.delete_all    
    each_row('judgments.csv') do |row|
      begin
        FttDecision.create(id: row['judgment_id'],
                         tribunal: row['tribunal'],
                         chamber: row['chamber'],
                         chamber_group: row['chamber_group'],
                         decision_date: read_date(row['decision_datetime'],'%m/%d/%Y'),
                         created_datetime: read_date(row['created_datetime'],'%m/%d/%Y'),
                         publication_date: read_date(row['publication_datetime'],'%m/%d/%Y'),
                         last_updatedtime: read_date(row['last_updatedtime'],'%m/%d/%Y'),
                         file_number: row['file_number'],
                         file_no_1: row['file_no_1'],
                         file_no_2: row['file_no_2'],
                         claimant: row['claimant'],
                         respondent: row['respondent'],
                         notes: row['notes'],
                         is_published: row['is_published'],
                         old_main_subcategory_id: row['subcategory_id'],
                         old_sec_subcategory_id: row['sec_subcategory_id']
                         )
      rescue StandardError => e
        puts e
        puts "Failed to import #{row['judgment_id']}"
      end
    end
  end

  def import_categories
    FttCategory.delete_all
    each_row('categories.csv') do |row|
      begin
        FttCategory.create(id: row['category_id'], name: row['category_name'])
      rescue StandardError => e
        puts e
        puts "Failed to import #{row['category_id']} - #{row['category_name']}"
      end
    end    
  end

  def import_subcategories
    FttSubcategory.delete_all
    each_row('subcategories.csv') do |row|
      begin
        if c = FttCategory.find(row['category_id'])
          sc = c.ftt_subcategories.create(id: row['subcategory_id'], name: row['subcategory_name'])
        else
          puts "Could not find category with id #{row['category_id']}"
        end
      rescue StandardError => e
        puts e
        puts "Failed to import #{row['subcategory_id']} - #{row['subcategory_name']}"
      end
    end
  end

  def import_judges
    FttJudge.delete_all
    each_row('judges.csv') do |row|
      begin
        FttJudge.create(id: row['judge_id'], name: row['judge_name'])
      rescue StandardError => e
        puts e
        puts "Failed to import #{row['judge_id']} - #{row['judge_name']}"
      end
    end
  end  


  def import_judges_judgments_mapping
    FttJudgment.delete_all    
    each_row('judges_judgments_map.csv') do |row|
      begin
        d = FttDecision.find(row['judgment_id'])
        d.ftt_judges << FttJudge.find(row['judge_id'].to_i)
      rescue Exception => e
        puts e.message  
        puts e.backtrace.inspect  
      end
    end    
  end
end
