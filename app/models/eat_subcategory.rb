class EatSubcategory < ActiveRecord::Base
  belongs_to :eat_category
  has_many :eat_category_decisions
  has_many :eat_decisions, through: :eat_category_decisions
end
