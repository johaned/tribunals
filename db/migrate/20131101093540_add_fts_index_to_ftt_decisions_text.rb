class AddFtsIndexToFttDecisionsText < ActiveRecord::Migration
  disable_ddl_transaction!

  def up
    execute "CREATE INDEX CONCURRENTLY ftt_decisions_text_fts_idx ON ftt_decisions USING gin(to_tsvector('english', text))"
  end

  def down
    execute "DROP INDEX ftt_decisions_text_fts_idx"
  end
end
