class CreateEatCategoryManagers < ActiveRecord::Migration
  def change
    create_table :eat_category_managers do |t|
      t.references :eat_subcategory
      t.references :eat_category
      t.string :eat_subcategory_name
      t.string :obsolete
      t.string :rank

      t.timestamps
    end
  end
end
