class AddSearchIndexToArticles < ActiveRecord::Migration
  def up
    execute "create index text_search on decisions using gin(to_tsvector('english', text))"
  end

  def down
    execute "drop index text_search"
  end
end
