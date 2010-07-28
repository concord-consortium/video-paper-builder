When /^I visit invite_user_path$/ do
  Given 'I am logged in as the default user'
  visit '/users/invitation/new'
  click_button 'Send an invitation'
end

Then /^I should see an error message$/ do
  page.should have_css('.alert')
end

