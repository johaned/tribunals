class Judge < ActiveRecord::Base
  has_many :aac_judgements
  has_many :aac_decisions, through: :aac_judgements

  def self.list
    order('name ASC').pluck("name AS judge")
  end
end
