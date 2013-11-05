class IacAllFieldsFtsIndex < ActiveRecord::Migration
  disable_ddl_transaction!
  
  def up
    execute "CREATE INDEX CONCURRENTLY iac_all_fields_combined_fts_index ON decisions using gin(to_tsvector('english', coalesce(ncn::text, '') || ' ' || char_array_to_text(judges) || ' ' || char_array_to_text(categories) || ' ' || char_array_to_text(keywords) || ' ' || coalesce(appeal_number::text, '') || ' ' || coalesce(case_notes::text, '') || ' ' || coalesce(claimant::text, '') || ' ' || coalesce(country::text, '') || ' ' || coalesce(case_name::text, '') || ' ' || coalesce(text::text, '')))"
  end

  def down
    execute "DROP INDEX iac_all_fields_combined_fts_index"
  end
end
