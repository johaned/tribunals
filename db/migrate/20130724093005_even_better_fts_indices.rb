class EvenBetterFtsIndices < ActiveRecord::Migration
  def change
    execute "DROP INDEX decisions_fts_idx_before_jun1"
    execute "DROP INDEX decisions_fts_idx_after_jun1"

    execute "CREATE INDEX decisions_fts_idx_after_jun1 ON decisions USING gin(to_tsvector('english', text)) WHERE promulgated_on >= '2013-06-01' OR reported = 't'"
    execute "CREATE INDEX decisions_fts_idx ON decisions USING gin(to_tsvector('english', text))"
  end
end
