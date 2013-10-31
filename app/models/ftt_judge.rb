class FttJudge < ActiveRecord::Base
  has_many :ftt_judgments
  has_many :ftt_decisions, through: :ftt_judgments
end
