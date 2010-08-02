Then /^I should have five sections$/ do
  page.should have_content('Sections')
  page.should have_content('Introduction')
  page.should have_content('Getting Started')
  page.should have_content('Inquiry')
  page.should have_content('Conclusion')
end

