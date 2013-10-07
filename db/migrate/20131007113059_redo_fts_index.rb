class RedoFtsIndex < ActiveRecord::Migration
  disable_ddl_transaction!

  def change
    execute "DROP INDEX decisions_fts_idx"
    execute "CREATE INDEX CONCURRENTLY decisions_fts_idx ON decisions USING gin(to_tsvector('english', text))"
  end
end
