class CreateImportErrors < ActiveRecord::Migration
  def change
    create_table :import_errors do |t|
      t.string :url
      t.date :promulgated_on
      t.string :error
      t.text :backtrace

      t.timestamps
    end
  end
end
