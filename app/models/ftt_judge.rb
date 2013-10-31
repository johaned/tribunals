class FttJudge < ActiveRecord::Base
  has_many :ftt_judgments
  has_many :ftt_decisions, through: :ftt_judgments

  def self.list
    order('name ASC').pluck("name AS judge")
  end
end
