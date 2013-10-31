class CreateFttJudges < ActiveRecord::Migration
  def change
    create_table :ftt_judges do |t|
      t.string :name      

      t.timestamps
    end
  end
end
