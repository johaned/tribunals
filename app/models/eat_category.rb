class EatCategory < ActiveRecord::Base
  has_many :eat_subcategories

  def self.list
    order('name ASC').pluck("name AS category")
  end
end
