class CreateFttSubcategoriesDecisions < ActiveRecord::Migration
  def change
    create_table :ftt_subcategories_decisions do |t|
      t.belongs_to :ftt_subcategory
      t.belongs_to :ftt_decision

      t.timestamps
    end
  end
end
