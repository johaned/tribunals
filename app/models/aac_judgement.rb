class AacJudgement < ActiveRecord::Base
  belongs_to :aac_decision
  belongs_to :judge
end
