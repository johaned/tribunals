class BetterFtsIndices < ActiveRecord::Migration
  def change
    execute "DROP INDEX text_search"
    execute "DROP INDEX decisions_to_tsvector_idx"
    
    execute "CREATE INDEX decisions_fts_idx_after_jun1 ON decisions USING gin(to_tsvector('english', text)) WHERE promulgated_on >= '2013-06-01'"
    execute "CREATE INDEX decisions_fts_idx_before_jun1 ON decisions USING gin(to_tsvector('english', text)) WHERE promulgated_on < '2013-06-01'"
  end
end
