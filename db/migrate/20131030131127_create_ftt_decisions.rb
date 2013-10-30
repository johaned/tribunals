class CreateFttDecisions < ActiveRecord::Migration
  def change
    create_table :ftt_decisions do |t|
      t.text :claimant
      t.string :respondent
      t.text :text
      t.text :html

      t.string :doc_url
      t.string :doc_file
      t.string :pdf_file

      t.string :file_no_1
      t.string :file_no_2
      t.string :file_number

      t.integer :old_main_subcategory_id
      t.integer :old_sec_subcategory_id

      t.string :tribunal
      t.string :chamber
      t.string :chamber_group      

      t.string :slug

      t.boolean :is_published

      t.text :notes

      t.date :decision_date
      t.date :hearing_date
      t.date :publication_date
      t.date :last_updatedtime
      t.date :created_datetime

      t.timestamps
    end
  end
end
