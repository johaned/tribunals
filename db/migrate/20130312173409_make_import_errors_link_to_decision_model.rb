class MakeImportErrorsLinkToDecisionModel < ActiveRecord::Migration
  def up
    add_column :decisions, :url, :string
    add_column :import_errors, :decision_id, :integer
    remove_column :import_errors, :url
    remove_column :import_errors, :promulgated_on
  end

  def down
    remove_column :decisions, :url
    remove_column :import_errors, :decision_id
    add_column :import_errors, :url, :string
    add_column :import_errors, :promulgated_on, :date
  end
end
