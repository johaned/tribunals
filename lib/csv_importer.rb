require 'csv'

class CSVImporter
  def initialize(directory, logger=Rails.logger)
    @directory = directory
    @logger = logger
  end
  
  def each_row(fn, &blk)
    CSV.foreach(filename(fn), headers: :first_row, &blk)
  end
  
  def filename(fn)
    File.join(@directory, fn)
  end

  def import_decisions
    AacDecision.delete_all    
    each_row('judgements.csv') do |row|
      create_decision(row)
    end
  end

  def import_categories
    AacDecisionCategory.delete_all
    each_row('categories.csv') do |row|
      create_category(row)
    end
  end

  def import_subcategories
    AacDecisionSubcategory.delete_all
    each_row('subcategories.csv') do |row|
      create_subcategory(row)
    end
  end

  def import_judges
    Judge.delete_all
    each_row('judges.csv') do |row|
      create_judge(row)
    end
  end

  def import_decisions_judges_mapping
    AacJudgement.delete_all    
    each_row('judges_judgements_map.csv') do |row|
      create_aac_judgements(row)
    end    
  end

  def run
    each_row('judgment.csv') do |row|
      if decision = find_decision(row['Doc_name'], compute_ncn(row))
        update_judgment(decision, row)
      else
        create_judgment(row)
      end
    end
  end

  def find_decision(filename, ncn)
    Decision.where('doc_file = ? or ncn = ?', filename, ncn).first
  end

  def compute_ncn(row)
    "[#{row['ncn_year']}] #{row['ncn_code']} #{row['ncn_citation']}"
  end

  def read_date(value, format=nil)
    return nil unless value
    format.nil? ? Date.parse(value.split(/ /).first) : Date.strptime(value, format)
  end

  def update_judgment(decision, row)
    decision.promulgated_on = read_date(row['promulgated_datetime'])
    decision.hearing_on = read_date(row['hearing_datetime'])
    decision.created_at = Time.parse(row['created_datetime'])
    decision.updated_at = Time.parse(row['last_updatetime'])
    if (published_on = read_date(row['published_datetime'])).present?
      decision.published_on = published_on
    end

    appeal_number = [row['file_no_1'], row['file_no_2'], row['file_no_3']].join('/')
    if /\A[A-Z]{2}\/[0-9]{5}\/[0-9]{4}\Z/ =~ appeal_number
      decision.appeal_number = appeal_number
    end

    decision.starred = row['is_starred'] == '1'
    decision.country_guideline = row['is_countryguide'] == '1'

    decision.claimant = row['claimant']
    decision.keywords = row.inject([]) do |acc, (k, v)|
      acc << v if /keyword/ =~ k && v.present?
      acc
    end
    decision.case_notes = row['case_notes']
    decision.judges = judges_for(row['id'])

    pp decision.id, decision.changes

    if !decision.valid? && decision.errors.keys == [:doc_file] || decision.errors.keys == [:judges]
      decision.save!(validate: false)
      return
    end

    decision.save!
  end

  def create_judgment(row)
    puts "No new judgments should be created, skipping."
  end

  def create_decision(row)
    begin
      d = AacDecision.new(id: row['judgement_id'],
                       tribunal: row['tribunal'],
                       chamber: row['chamber'],
                       chamber_group: row['chamber_group'],
                       hearing_date: read_date(row['hearing_datetime'],'%m/%d/%Y'),
                       decision_date: read_date(row['decision_datetime'],'%m/%d/%Y'),
                       created_datetime: read_date(row['created_datetime'],'%m/%d/%Y'),
                       publication_date: read_date(row['publication_datetime'],'%m/%d/%Y'),
                       last_updatedtime: read_date(row['last_updatedtime'],'%m/%d/%Y'),
                       file_number: row['file_number'],
                       file_no_1: row['file_no_1'],
                       file_no_2: row['file_no_2'],
                       file_no_3: row['file_no_3'],
                       reported_number: row['reported_number'],
                       reported_no_1: row['reported_no_1'],
                       reported_no_2: row['reported_no_2'],
                       reported_no_3: row['reported_no_3'],
                       ncn: row['neutral_citation_number'],
                       ncn_year: row['ncn_year'],
                       ncn_code1: row['ncn_code1'],
                       ncn_citation: row['ncn_citation'],
                       ncn_code2: row['ncn_code2'],
                       claimant: row['claimant'],
                       respondent: row['respondent'],
                       notes: row['notes'],
                       is_published: row['is_published'],
                       aac_decision_subcategory_id: row['subcategory_id'],
                       old_sec_subcategory_id: row['sec_subcategory_id'],
                       keywords: row['keywords']
                       )
      d.save
    rescue StandardError => e
      puts e
      puts "Failed to import #{row['judgement_id']}"
    end
  end

  def create_category(row)
    c = AacDecisionCategory.new(id: row['category_id'], name: row['category_name'])
    puts "Failed to import #{row['category_id']} - #{row['category_name']}" unless c.save
  end

  def create_subcategory(row)
    if c = AacDecisionCategory.find(row['category_id'])
      sc = c.aac_decision_subcategories.new(id: row['subcategory_id'], name: row['subcategory_name'])
      puts "Failed to import #{row['subcategory_id']} - #{row['subcategory_name']}" unless sc.save
    else
      puts "Could not find category with id #{row['category_id']}"
    end
  end

  def create_judge(row)
    j = Judge.new(id: row['judge_id'], name: row['judge_name'])
    puts "Failed to import #{row['judge_id']} - #{row['judge_name']}" unless j.save    
  end    

  def create_aac_judgements(row)
    begin
      d = AacDecision.find(row['judgement_id'])
      d.judges << Judge.find(row['judge_id'].to_i)
    rescue Exception => e
      puts e.message  
      puts e.backtrace.inspect  
    end
  end

  def judges_for(judgment_id)
    judge_ids_for(judgment_id).inject([]) do |acc, jid|
      if value = judge(jid)
        acc << value
      end
      acc
    end
  end

  def judge_ids_for(judgment_id)
    @judge_ids_map ||= \
    begin
      Hash.new { [] }.tap do |map|
        each_row('commissioner_judgment_map.csv') do |row|
          map[row['judgment_id']] <<= row['commissioner_id']
        end
      end
    end

    @judge_ids_map[judgment_id]
  end

  def judge(judge_id)
    @judge_ids ||= \
    begin
      {}.tap do |map|
        each_row('commissioner.csv') do |row|
          map[row['id']] = [row['prefix'], row['name'], row['postfix']].join(' ').strip
        end
      end
    end

    @judge_ids[judge_id]
  end
end


