require 'spec_helper'

describe 'search decisions in main page' do
  before do
    @decision1 = Decision.create!(decision_hash(ncn: '[2013] ACAC 789', text: 'ministry justice england allambra persons'))
    @decision2 = Decision.create!(decision_hash(ncn: '[2013] ACAC 790', text: '[2013] ACAC 789', country: 'England', keywords: %w(person people), claimant: 'Edgar'))
    @decision3 = Decision.create!(decision_hash(text: 'AA/11055/2010 london edgar', case_notes: 'ministry Person'))
    @decision4 = Decision.create!(decision_hash(appeal_number: 'AA/11055/2010', categories: %w(justice family), judges: %w(Allam Johan), reported: false))
  end
  context 'when a user search through free text search' do
    it 'search a word contained into the Text and NCN decision attributes', :js do
      query = '[2013] ACAC 789'
      visit root_path
      fill_in 'search[query]', :with => query
      within('.input-append') do
        click_button 'Search'
      end
      # --> checking the first result
      # - checking the result title
      # - Example how to make the query with xpath
      #page.find(:xpath,'//*[@id="content"]/div/form/div[4]/div[2]/table/tr[2]/td[1]/a').should have_content('[2013] ACAC 789')
      # - Example how to make the query with selector
      #page.find('.decisions table tr:eq(2) td:eq(1)').should have_content('[2013] ACAC 789')
      # - More readable query
      page.find('.decisions table').find(:row, 2).find(:column, 1).should have_content(@decision1.ncn)
      # - checking the highlighting
      page.find('.decisions table').find(:row, 2).find(:column, 1).find('.highlight').should have_content(query)

      # --> checking the second result
      # - checking the result title
      page.find('.decisions table').find(:row, 5).find(:column, 1).should have_content(@decision2.ncn)
      # - checking the highlighting
      page.find('.decisions table').find(:row, 7).find(:column, 1).find('.highlight').should have_content(query)
    end

    it 'search a word contained into the Text, Case Notes and Keywords decision attributes', :js do
      query = 'person'
      visit root_path
      fill_in 'search[query]', :with => query
      within('.input-append') do
        click_button 'Search'
      end
      # --> checking the first result
      # - checking the result title
      page.find('.decisions table').find(:row, 2).find(:column, 1).should have_content(@decision2.ncn)
      ## - checking the highlighting
      page.find('.decisions table').find(:row, 3).find('td .highlight').should have_content(query)

      ## --> checking the second result
      ## - checking the result title
      page.find('.decisions table').find(:row, 5).find(:column, 1).should have_content(@decision3.ncn)
      ## - checking the highlighting
      # Because the case notes is not appear in the results search page, no fields are highlighted

      ## --> checking the third result
      ## - checking the result title
      page.find('.decisions table').find(:row, 8).find(:column, 1).should have_content(@decision1.ncn)
      ## - checking the highlighting
      page.find('.decisions table').find(:row, 10).find(:column, 1).should have_content(query)
    end

    it 'search a word contained into the Text and Judges decision attributes', :js do
      query = 'Allam'
      visit root_path
      fill_in 'search[query]', :with => query
      within('.input-append') do
        click_button 'Search'
      end
      # --> checking the first result
      # - checking the result title
      page.find('.decisions table').find(:row, 2).find(:column, 1).should have_content(@decision4.appeal_number)
      ## - checking the highlighting
      # Because the judges is not appear in the results search page, no fields are highlighted

      ## --> checking the second result
      ## - checking the result title
      page.find('.decisions table').find(:row, 5).find(:column, 1).should have_content(@decision1.ncn)
      ## - checking the highlighting
      page.find('.decisions table').find(:row, 7).find('td .highlight').should have_content(query.downcase)
    end

    it 'search a word contained into the Text and Claimant decision attributes', :js do
      query = 'Edgar'
      visit root_path
      fill_in 'search[query]', :with => query
      within('.input-append') do
        click_button 'Search'
      end
      # --> checking the first result
      # - checking the result title
      page.find('.decisions table').find(:row, 2).find(:column, 1).should have_content(@decision2.ncn)
      ## - checking the highlighting
      page.find('.decisions table').find(:row, 3).find('td .highlight').should have_content(query)

      ## --> checking the second result
      ## - checking the result title
      page.find('.decisions table').find(:row, 5).find(:column, 1).should have_content(@decision3.ncn)
      ## - checking the highlighting
      page.find('.decisions table').find(:row, 7).find('td .highlight').should have_content(query.downcase)
    end

    it 'search a word contained into the Text and Country decision attributes', :js do
      query = 'England'
      visit root_path
      fill_in 'search[query]', :with => query
      within('.input-append') do
        click_button 'Search'
      end
      # --> checking the first result
      # - checking the result title
      page.find('.decisions table').find(:row, 2).find(:column, 1).should have_content(@decision2.ncn)
      ## - checking the highlighting
      page.find('.decisions table').find(:row, 2).find(:column, 4).find('.highlight').should have_content(query)

      ## --> checking the second result
      ## - checking the result title
      page.find('.decisions table').find(:row, 5).find(:column, 1).should have_content(@decision1.ncn)
      ## - checking the highlighting
      page.find('.decisions table').find(:row, 7).find('td .highlight').should have_content(query.downcase)
    end

    it 'search a word contained into the Text and Categories decision attributes', :js do
      query = 'justice'
      visit root_path
      fill_in 'search[query]', :with => query
      within('.input-append') do
        click_button 'Search'
      end
      # --> checking the first result
      # - checking the result title
      page.find('.decisions table').find(:row, 2).find(:column, 1).should have_content(@decision4.appeal_number)
      ## - checking the highlighting
      # Because the categories is not appear in the results search page, no fields are highlighted

      ## --> checking the second result
      ## - checking the result title
      page.find('.decisions table').find(:row, 5).find(:column, 1).should have_content(@decision1.ncn)
      ## - checking the highlighting
      page.find('.decisions table').find(:row, 7).find('td .highlight').should have_content(query.downcase)
    end

    it 'search a word contained into the Text and Appeal Number decision attributes', :js do
      query = 'AA/11055/2010'
      visit root_path
      fill_in 'search[query]', :with => query
      within('.input-append') do
        click_button 'Search'
      end
      # --> checking the first result
      # - checking the result title
      page.find('.decisions table').find(:row, 2).find(:column, 1).should have_content(@decision4.appeal_number)
      ## - checking the highlighting
      page.find('.decisions table').find(:row, 2).find(:column, 1).find('.highlight').should have_content(query)

      ## --> checking the second result
      ## - checking the result title
      page.find('.decisions table').find(:row, 5).find(:column, 1).should have_content(@decision3.ncn)
      ## - checking the highlighting
      page.find('.decisions table').find(:row, 7).find('td .highlight').should have_content(query)
    end
  end
end
