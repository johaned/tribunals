class FttSubcategoriesDecision < ActiveRecord::Base
  belongs_to :ftt_decision
  belongs_to :ftt_subcategory
end
