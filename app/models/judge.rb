class Judge < ActiveRecord::Base
  has_many :aac_judgements
  has_many :aac_decisions, through: :aac_judgements
end
