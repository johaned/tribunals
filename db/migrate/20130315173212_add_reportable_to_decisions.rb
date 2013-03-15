class AddReportableToDecisions < ActiveRecord::Migration
  def change
    add_column :decisions, :reportable, :boolean
  end
end
