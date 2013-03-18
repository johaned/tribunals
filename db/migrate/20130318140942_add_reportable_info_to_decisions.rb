class AddReportableInfoToDecisions < ActiveRecord::Migration
  def change
    add_column :decisions, :starred, :boolean
    add_column :decisions, :panel, :boolean
    add_column :decisions, :country_guideline, :boolean
    add_column :decisions, :judges, :string, :array => true, :default => '{}'
    add_column :decisions, :categories, :string, :array => true, :default => '{}'
    add_column :decisions, :country, :string
    add_column :decisions, :claiments, :string
    add_column :decisions, :keywords, :string, :array => true, :default => '{}'
    add_column :decisions, :case_notes, :string
  end
end
