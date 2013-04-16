class SpellClaimentCorrectly < ActiveRecord::Migration
  def change
    rename_column :decisions, :claiments, :claimant
  end
end
