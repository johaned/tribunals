class CreateAacDecisionCategories < ActiveRecord::Migration
  def change
    create_table :aac_decision_categories do |t|
      t.string :name
      t.timestamps
    end
  end
end
