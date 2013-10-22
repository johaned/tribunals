class ChangeAacNotesType < ActiveRecord::Migration
  def change
    change_column :aac_decisions, :notes, :text
  end
end
