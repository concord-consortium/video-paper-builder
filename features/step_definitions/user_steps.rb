Given /^the administrator "([^"]*)" invites a user "([^"]*)"$/ do |admin, user|
  Given "I am an admin logged in as \"#{admin}\""
  When "I go to the user invitation page"
  fill_in 'Email', :with=>user
  click_button 'Send an invitation'
end
