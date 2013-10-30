module EatDecisionsHelper
  #TODO: Add page_title helper which does not conflict with other helpers
  def link_label(eat_decision)
    eat_decision.file_number
  end

  def display_starred(eat_decision)
    eat_decision.starred ? "Yes" : "No"
  end
end

