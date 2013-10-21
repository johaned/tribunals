class CreateAacImportErrors < ActiveRecord::Migration
  def change
    create_table :aac_import_errors do |t|
      t.string :url
      t.string :error
      t.text :backtrace
      t.references :aac_decision

      t.timestamps

    end
  end
end
