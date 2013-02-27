class AddTextToDecisions < ActiveRecord::Migration
  def change
    add_column :decisions, :text, :text
  end
end
