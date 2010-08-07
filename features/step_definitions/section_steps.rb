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
  video_paper = VideoPaper.find_by_title(paper)
  user = User.find_by_email(user)
  shared_paper_parms = {
    :user_id => user.id,
    :video_paper_id => video_paper.id
  }
  video_paper.share(shared_paper_parms)
end

