class AacDecisionCategory < ActiveRecord::Base
  has_many :aac_decisions
  has_many :aac_decision_subcategories
end
