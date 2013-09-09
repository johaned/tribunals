class Feedback
  include ActiveModel::Model
  attr_accessor :rating, :text, :email
  validates :rating, :text, :presence => true
end
