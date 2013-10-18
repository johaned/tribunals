class AddCategoryRefToAacDecisions < ActiveRecord::Migration
  def change
    add_reference :aac_decisions, :aac_decisions_category, index: true
  end
end
