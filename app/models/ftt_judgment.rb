class FttJudgment < ActiveRecord::Base
  belongs_to :ftt_decision
  belongs_to :ftt_judge
end
