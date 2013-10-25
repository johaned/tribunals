require 'spec_helper'

describe 'search decisions in main page' do
  before do
    #let (:decision1){Decision.create!(decision_hash(ncn: '[2013] ACAC 789', text: 'ministry justice england allambra persons'))}
    #let (:decision2){Decision.create!(decision_hash(text: '[2013] ACAC 789', country: 'England', keywords: %w(person people), claimant: 'Edgar'))}
    #let (:decision3){Decision.create!(decision_hash(text: 'AA/11055/2010 london edgar allam person', case_notes: 'ministry'))}
    #let (:decision4){Decision.create!(decision_hash(appeal_number: 'AA/11055/2010', categories: %w(justice family), judges: %w(Allam Johan), reported: false))}
    @decision1 = Decision.create!(decision_hash(ncn: '[2013] ACAC 789', text: 'ministry justice england allambra persons'))
    @decision2 = Decision.create!(decision_hash(text: '[2013] ACAC 789', country: 'England', keywords: %w(person people), claimant: 'Edgar'))
    @decision3 = Decision.create!(decision_hash(text: 'AA/11055/2010 london edgar allam person', case_notes: 'ministry'))
    @decision4 = Decision.create!(decision_hash(appeal_number: 'AA/11055/2010', categories: %w(justice family), judges: %w(Allam Johan), reported: false))
  end
  context 'when a user search through free text search' do
    #before { decision1 ; decision2}
    it 'search a word contained into the Text decision attribute' do
      visit root_path
      fill_in 'search[query]', :with => '[2013] ACAC 789'
      click_button 'Search'
      # --> checking the first result
      # - checking the result title
      page.find('.decisions table .even.first:eq(0) td:eq(0)').should have_content('[2013] ACAC 789')
      # - checking the highlighting
      page.find('.decisions table .even.first:eq(0) td:eq(0) .result').should have_content('[2013] ACAC 789')
      # --> checking the second result
      # - checking the result title
      page.find('.decisions table .even.first:eq(1) td:eq(0)').should have_content(decision_path(@decision2))
      page.find('.decisions table .last.odd:eq(1) td:eq(0) .result').should have_content('[2013] ACAC 789')
    end
  end
end
