class CreateFttSubcategories < ActiveRecord::Migration
  def change
    create_table :ftt_subcategories do |t|
      t.string :name
      t.references :ftt_category

      t.timestamps
    end
  end
end
