require 'csv_importer'

class EATImporter < CSVImporter

  def import_judgments
    EatDecision.delete_all
    each_row('judgments.csv') do |row|
      create_decision(row)
    end
  end

  def create_decision(row)
    begin
      d = EatDecision.new(id: row['id'],
                          hearing_date: read_date(row['date'],'%m/%d/%Y'),
                          upload_date: read_date(row['upload_date'],'%m/%d/%Y'),
                          file_number: row['eatnum'],
                          claimant: row['appellant'],
                          filename: row['filename'],
                          uploaded_by: row['uploaded_by'],
                          judges: row['judges'],
                          respondent: row['respondent'],
                          starred: row['starred'].upcase == 'Y')
      d.save
    rescue StandardError => e
      puts e
      puts "Failed to import #{row['id']}"
    end
  end

  def import_js1
    EatCategory.delete_all
    each_row('jurisdiction_level1.csv') do |row|
      create_category(row)
    end
  end

  def create_category(row)
    begin
      c = EatCategory.new(id: row['id'],
                          name: row['title'],
                          obsolete: row['obsolete'])
      c.save
    rescue StandardError => e
      puts e
      puts "Failed to import #{row['id']}"
    end
  end

  def import_js2
    EatSubcategory.delete_all
    each_row('jurisdiction_level2.csv') do |row|
      create_subcategory(row)
    end
  end

  def create_subcategory(row)
    begin
      s = EatSubcategory.new(id: row['id'],
                             name: row['name'],
                             eat_category_id: row['category_id'],
                             obsolete: row['obsolete'],
                             rank: row['rank'])
      s.save
    rescue StandardError => e
      puts e
      puts "Failed to import #{row['id']}"
    end
  end

  def import_category_decision
    EatCategoryDecision.delete_all
    each_row('judgment_jurisdictions.csv') do |row|
      create_category_decision(row)
    end
  end

  def create_category_decision(row)
    begin
      cd = EatCategoryDecision.new(eat_decision_id: row['eat_decision_id'],
                                   eat_subcategory_id: row['eat_subcategory_id'],
                                   primary_jurisdiction: row['primary_jurisdiction'])
      cd.save
    rescue StandardError => e
      puts e
      puts "Failed to import #{row['eat_decision_id']}"
    end
  end

end
