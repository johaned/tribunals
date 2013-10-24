class AacDecisionSubcategory < ActiveRecord::Base
  has_many :aac_decisions
  belongs_to :aac_decision_category

  def self.list
    order('name ASC').pluck("name AS subcategory")
  end
end
