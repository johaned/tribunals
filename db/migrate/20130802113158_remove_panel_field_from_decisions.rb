class RemovePanelFieldFromDecisions < ActiveRecord::Migration
  def change
    remove_column :decisions, :panel
  end
end
