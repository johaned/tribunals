class CreateFttCategories < ActiveRecord::Migration
  def change
    create_table :ftt_categories do |t|
      t.string :name
      t.timestamps
    end
  end
end
