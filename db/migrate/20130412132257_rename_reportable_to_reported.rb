class RenameReportableToReported < ActiveRecord::Migration
  def change
    rename_column :decisions, :reportable, :reported
  end
end
