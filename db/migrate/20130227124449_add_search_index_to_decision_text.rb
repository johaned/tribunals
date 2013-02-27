class AddSearchIndexToDecisionText < ActiveRecord::Migration
  def change
    execute "create index on decisions using gin(to_tsvector('english', text));"
  end
end
