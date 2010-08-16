Then /^I should have five sections$/ do
  page.should have_css('#introduction')
  page.should have_css('#getting_started')
  page.should have_css('#inquiry')
  page.should have_css('#wrapping_up')
  page.should have_css('#conclusion')
end

Then /^the conclusion tab should be current$/ do
  page.should have_css('#conclusion_tab.ui-tabs-selected')
  page.should_not have_css('#introduction_tab.ui-tabs-selected')
  page.should_not have_css('#getting_started_tab.ui-tabs-selected')
  page.should_not have_css('#wrapping_up_tab.ui-tabs-selected')
  page.should_not have_css('#inquiry_tab.ui-tabs-selected')
end

Then /^the introduction tab should be current$/ do
  page.should_not have_css('#conclusion_tab.ui-tabs-selected')
  page.should have_css('#introduction_tab.ui-tabs-selected')
  page.should_not have_css('#getting_started_tab.ui-tabs-selected')
  page.should_not have_css('#wrapping_up_tab.ui-tabs-selected')
  page.should_not have_css('#inquiry_tab.ui-tabs-selected')
end

Then /^the inquiry tab should be current$/ do
  page.should_not have_css('#conclusion_tab.ui-tabs-selected')
  page.should_have_css('#introduction_tab.ui-tabs-selected')
  page.should have_css('#getting_started_tab.ui-tabs-selected')
  page.should_not have_css('#wrapping_up_tab.ui-tabs-selected')
  page.should_not have_css('#inquiry_tab.ui-tabs-selected')
end

Then /^the wrapping up tab should be current$/ do
  page.should_not have_css('#conclusion_tab.ui-tabs-selected')
  page.should_not have_css('#introduction_tab.ui-tabs-selected')
  page.should_not have_css('#getting_started_tab.ui-tabs-selected')
  page.should have_css('#wrapping_up_tab.ui-tabs-selected')
  page.should_not have_css('#inquiry_tab.ui-tabs-selected')
end

Then /^the getting started tab should be current$/ do
  page.should_not have_css('#conclusion_tab.ui-tabs-selected')
  page.should_not have_css('#introduction_tab.ui-tabs-selected')
  page.should have_css('#getting_started_tab.ui-tabs-selected')
  page.should_not have_css('#wrapping_up_tab.ui-tabs-selected')
  page.should_not have_css('#inquiry_tab.ui-tabs-selected')
end

Then /^I share "([^"]*)" with "([^"]*)"$/ do |paper, user|
  When "I go to #{paper}'s sharing page"
  Then "I should see \"Sharing Settings for #{paper}\""
  fill_in 'shared_paper_user_id', :with=> user
  Then "I press \"Share\""
end

Then /^I unshare "([^"]*)" with "([^"]*)"$/ do |paper, user|
  When "I go to #{paper}'s sharing page"
  Then "I should see \"Sharing Settings for #{paper}\""
  click_link_or_button("unshare")
end

When /^I add "([^"]*)" to "([^"]*)"$/ do |content,finder|
  ##
  # This is probably the biggest hackety hack of the entire project.
  # The WYSIWYG editor drops an iframe and hides the section content text field, and then 
  # through dark magic populates it via the iframes' body inner html.  So thats what this
  # does.  Didn't want to throw out the tests.
  #
  page.evaluate_script("document.getElementById(\"#{finder}\").contentWindow.document.body.innerHTML = \"#{content}\";") 
end


