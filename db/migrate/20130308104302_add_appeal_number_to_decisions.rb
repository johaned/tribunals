class AddAppealNumberToDecisions < ActiveRecord::Migration
  def change
    add_column :decisions, :appeal_number, :string
  end
end
