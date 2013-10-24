class CreateEatCategoryDecisions < ActiveRecord::Migration
  def change
    create_table :eat_category_decisions do |t|
      t.references :eat_decision
      t.references :eat_subcategory
      t.references :eat_category
      t.integer :primary_jurisdiction

      t.timestamps
    end
  end
end
