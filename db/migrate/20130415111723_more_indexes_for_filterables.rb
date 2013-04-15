class MoreIndexesForFilterables < ActiveRecord::Migration
  def change
    add_index :decisions, :reported
    add_index :decisions, :country_guideline
    add_index :decisions, :country
    add_index :decisions, :judges
  end
end
