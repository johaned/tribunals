class CreateFttJudgments < ActiveRecord::Migration
  def change
    create_table :ftt_judgments do |t|
      t.belongs_to :ftt_decision
      t.belongs_to :ftt_judge
      t.timestamps
    end
  end
end
