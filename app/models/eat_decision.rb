class EatDecision < ActiveRecord::Base
  has_many :eat_category_decisions
  has_many :eat_subcategories, through: :eat_category_decisions

  def self.ordered
    order("hearing_date DESC")
  end
end
