class AddPsqlCharToArrayFunction < ActiveRecord::Migration
  def up
    execute "CREATE OR REPLACE FUNCTION char_array_to_text(character varying[]) RETURNS text AS $$ SELECT array_to_string($1, ' ')::text $$ LANGUAGE SQL IMMUTABLE"
  end

  def down
    execute "DROP FUNCTION char_array_to_text(character varying[])"
  end
end
