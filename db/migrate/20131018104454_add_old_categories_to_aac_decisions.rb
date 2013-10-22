class AddOldCategoriesToAacDecisions < ActiveRecord::Migration
  def change
    add_column :aac_decisions, :old_main_subcategory_id, :integer
    add_column :aac_decisions, :old_sec_subcategory_id, :integer    
  end
end
