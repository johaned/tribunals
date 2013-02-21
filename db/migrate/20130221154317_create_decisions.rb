class CreateDecisions < ActiveRecord::Migration
  def change
    create_table :decisions do |t|
      t.string :doc_file
      t.date :promulgated_on
      t.text :html
      t.string :pdf_file

      t.timestamps
    end
  end
end
