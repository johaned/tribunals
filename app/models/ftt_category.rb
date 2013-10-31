class FttCategory < ActiveRecord::Base
  has_many :ftt_subcategories

  def self.list
    order('name ASC').pluck("name AS category")
  end
end
