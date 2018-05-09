When(/^I search for "([^"]*)"$/) do |search_term|
  on GoogleHomePage do |page|
    page.search search_term
  end
end

Then(/^I will receive results$/) do
  on GoogleResultsPage do |page|
    expect(page.results_stats).to match(/^About (\d+|\d{1,3}(,\d{3})*)(\.\d+)? results \(\d*\.?\d+ seconds\) $/)
  end
end
