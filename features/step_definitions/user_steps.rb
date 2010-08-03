Given /^the administrator "([^"]*)" invites a user "([^"]*)"$/ do |admin, user|
  Given "I am an admin logged in as \"#{admin}\""
  When "I go to the user invitation page"
  fill_in 'Email', :with=>user
  fill_in 'First name', :with=> "John"
  fill_in 'Last name', :with=> "Doe"
  click_button 'Send an invitation'
end
