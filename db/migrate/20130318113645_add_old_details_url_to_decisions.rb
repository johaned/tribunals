class AddOldDetailsUrlToDecisions < ActiveRecord::Migration
  def change
    add_column :decisions, :old_details_url, :string
  end
end
