# Add custom selectors Capybara-Based
Capybara.add_selector(:row) do
  xpath { |num| "./tbody/tr[#{num}]" }
end
Capybara.add_selector(:column) do
  xpath { |num| "./td[#{num}]" }
end
