class AddCaseNameToDecisions < ActiveRecord::Migration
  def change
    add_column :decisions, :case_name, :string
  end
end
