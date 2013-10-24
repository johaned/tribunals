class AacDecisionCategory < ActiveRecord::Base
  has_many :aac_decisions
  has_many :aac_decision_subcategories

  def self.list
    order('name ASC').pluck("name AS category")
  end
end
