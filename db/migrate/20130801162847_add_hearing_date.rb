class AddHearingDate < ActiveRecord::Migration
  def change
    add_column :decisions, :hearing_on, :date
  end
end
