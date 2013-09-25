class UkitDecisionsRicherMetadata < ActiveRecord::Migration
  def change
    change_table :decisions do |t|
      t.date :published_on
    end
  end
end
