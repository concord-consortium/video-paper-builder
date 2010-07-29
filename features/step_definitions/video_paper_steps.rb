Then /^I create a new video paper named "([^\"]*)"$/ do |title|
  fill_in "Title", :with => title
  click_button "Create"
end

When /^I edit the video paper title named "([^\"]*)"$/ do |title|
  When "I go to #{title}'s video paper edit page"
  fill_in "Title", :with => "Updated #{title}"
  click_button "Update"
end

