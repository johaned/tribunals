class AddTribunalIdToDecisions < ActiveRecord::Migration
  def change
    add_column :decisions, :tribunal_id, :integer
  end
end
