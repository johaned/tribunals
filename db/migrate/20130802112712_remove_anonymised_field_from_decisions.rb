class RemoveAnonymisedFieldFromDecisions < ActiveRecord::Migration
  def change
    remove_column :decisions, :anonymised
  end
end
