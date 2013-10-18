class CreateAacDecisions < ActiveRecord::Migration
  def change
    create_table :aac_decisions do |t|
      t.string :claimant
      t.string :respondent
      t.text :text
      t.text :html

      t.string :doc_url
      t.string :doc_file
      t.string :pdf_file

      t.string :file_no_1
      t.string :file_no_2
      t.string :file_no_3
      t.string :file_number

      t.string :ncn_citation
      t.string :ncn_code1
      t.string :ncn_code2
      t.string :ncn_year
      t.string :ncn

      t.string :reported_no_1
      t.string :reported_no_2
      t.string :reported_no_3
      t.string :reported_number

      t.string :tribunal
      t.string :chamber
      t.string :chamber_group      

      t.string :slug

      t.boolean :is_published

      t.string :notes
      t.string :keywords

      t.date :decision_date
      t.date :hearing_date
      t.date :publication_date
      t.date :last_updatedtime
      t.date :created_datetime

      t.timestamps
    end
  end
end
