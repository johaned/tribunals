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

  def read_date(value)
    return nil unless value
    Date.parse(value.split(/ /).first)
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


