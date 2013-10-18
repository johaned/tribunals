class CreateAacJudgements < ActiveRecord::Migration
  def change
    create_table :aac_judgements do |t|
      t.belongs_to :aac_decision
      t.belongs_to :judge
      t.timestamps
    end
  end
end
