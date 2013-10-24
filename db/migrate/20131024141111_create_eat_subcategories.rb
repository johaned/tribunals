class CreateEatSubcategories < ActiveRecord::Migration
  def change
    create_table :eat_subcategories do |t|
      t.references :eat_category
      t.string :name
      t.string :obsolete
      t.string :rank

      t.timestamps
    end
  end
end
