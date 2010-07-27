When /^I visit admins_invitation_path$/ do
  visit "/admins/invitation/new"
end

Then /^I should not be able to invite administrator$/ do  
  Given "I am redirected to admin sign_in"
  page.should_not have_content('Send invitation')
end

When /^I visit admins_new_path$/ do
  visit "/admins/sign_up"
end

Then /^I should not be able to create an administrator$/ do
  Given "I am redirected to admin sign_in"
end

Then /^I am redirected to admin sign_in$/ do
  current_path.should == "/admins/sign_in"
end

Then /^I should be able to invite an administrator$/ do
  fill_in 'Email', :with=>"dummy_vpb_user@velir.com"
  click_button 'Send an invitation'
  page.should have_css('.notice', :content => "An email with instructions about how to set the password has been sent.")
end

Then /^I should be able to create an administrator$/ do
  fill_in 'Email', :with=>"dummy_vpb_admin@velir.com"
  fill_in 'Password', :with=>"funstuff"
  fill_in 'Password confirmation', :with=>"funstuff"
  click_button 'Sign up'
end
