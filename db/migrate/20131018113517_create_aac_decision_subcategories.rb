class CreateAacDecisionSubcategories < ActiveRecord::Migration
  def change
    create_table :aac_decision_subcategories do |t|
      t.string :name
      t.references :aac_decision_category

      t.timestamps
    end
  end
end
