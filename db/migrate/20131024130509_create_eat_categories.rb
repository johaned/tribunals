class CreateEatCategories < ActiveRecord::Migration
  def change
    create_table :eat_categories do |t|
      t.string :name
      t.string :obsolete

      t.timestamps
    end
  end
end
