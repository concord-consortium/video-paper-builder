Then /^I should have five sections$/ do
  page.should have_css('#introduction')
  page.should have_css('#getting_started')
  page.should have_css('#inquiry')
  page.should have_css('#wrapping_up')
  page.should have_css('#conclusion')
end
