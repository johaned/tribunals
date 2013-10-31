module FttDecisionsHelper
  #TODO: Add page_title helper which does not conflict with other helpers
  def link_label(ftt_decision)
    ftt_decision.file_number
  end

  def display_file_number(ftt_decision)
    ftt_decision.file_number || "Unkown"
  end
end

