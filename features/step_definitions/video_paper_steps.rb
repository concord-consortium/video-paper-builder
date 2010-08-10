Then /^I create a new video paper named "([^\"]*)"$/ do |title|
  fill_in "Title", :with => title
  click_button "Enter in notes"
end

When /^I edit the video paper title named "([^\"]*)"$/ do |title|
  When "I go to #{title}'s video paper edit page"
  fill_in "Title", :with => "Updated #{title}"
  click_button "Update"
end

Then /^I should see an embedded video$/ do
  page.should have_css('#kplayer')
end

Then /^I should not see an embedded video$/ do
  page.should_not have_css('#kplayer')
end

