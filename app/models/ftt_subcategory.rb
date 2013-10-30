class FttSubcategory < ActiveRecord::Base
  belongs_to :ftt_category
  has_many :ftt_subcategories_decisions
  has_many :ftt_decisions, through: :ftt_subcategories_decisions

  def self.list
    order('name ASC').pluck("name AS subcategory")
  end
end
