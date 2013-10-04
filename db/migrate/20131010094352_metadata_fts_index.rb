class MetadataFtsIndex < ActiveRecord::Migration
  disable_ddl_transaction!
  
  def up
    execute "CREATE OR REPLACE FUNCTION char_array_to_text(character varying[]) RETURNS text AS $$ SELECT array_to_string($1, ' ')::text $$ LANGUAGE SQL IMMUTABLE"
    execute "CREATE INDEX CONCURRENTLY metadata_fts_index ON decisions using gin(to_tsvector('english', ncn::text || ' ' || char_array_to_text(judges) || ' ' || char_array_to_text(categories) || ' ' || char_array_to_text(keywords) || ' ' || appeal_number::text || ' ' || case_notes::text || ' ' || claimant::text || ' ' || country::text || ' ' || case_name::text))"
  end

  def down
    execute "DROP INDEX metadata_fts_index"
    execute "DROP FUNCTION char_array_to_text(character varying[])"
  end
end
