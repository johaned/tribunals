class CreateEatDecisions < ActiveRecord::Migration
  def change
    create_table :eat_decisions do |t|
      t.string :claimant
      t.string :respondent

      t.text :text
      t.text :html
      t.string :doc_url
      t.string :doc_file
      t.string :pdf_file
      t.string :tribunal
      t.string :chamber
      t.string :chamber_group

      t.string :slug

      t.string :notes
      t.string :keywords

      t.date :decision_date
      t.date :hearing_date
      t.date :last_updatedtime

      t.string :filename
      t.string :file_number

      t.string :judges

      t.date :upload_date
      t.string :uploaded_by
      t.boolean :starred

      t.timestamps
    end
  end
end
