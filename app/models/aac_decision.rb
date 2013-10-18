class AacDecision < ActiveRecord::Base
  belongs_to :aac_decision_category
  belongs_to :aac_decision_subcategory
  has_many :aac_judgements
  has_many :judges, through: :aac_judgements
end
