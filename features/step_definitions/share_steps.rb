When /^I click the unshare button$/ do
  click_link_or_button('unshare')
end

Then /^I should see unshare button$/ do
  page.should have_css("unshare")
end
