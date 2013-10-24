class EatCategoryDecision < ActiveRecord::Base
  belongs_to :eat_decision
  belongs_to :eat_subcategory
end
