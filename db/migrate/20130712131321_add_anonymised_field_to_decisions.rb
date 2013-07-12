class AddAnonymisedFieldToDecisions < ActiveRecord::Migration
  def change
    add_column :decisions, :anonymised, :boolean, default: false
  end
end
