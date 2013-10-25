class AddFtsIndexToAacDecisionsText < ActiveRecord::Migration
  disable_ddl_transaction!

  def up
    execute "CREATE INDEX CONCURRENTLY aac_decisions_text_fts_idx ON aac_decisions USING gin(to_tsvector('english', text))"
  end

  def down
    execute "DROP INDEX aac_decisions_text_fts_idx"
  end
end
