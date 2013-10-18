class ChangeAacCategoryColumnNames < ActiveRecord::Migration
  def change
    rename_column :aac_decisions, :old_main_subcategory_id, :aac_decision_subcategory_id
  end
end
