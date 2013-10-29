class EatCategory < ActiveRecord::Base
  has_many :eat_subcategories
end
