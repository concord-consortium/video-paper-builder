Then /^I should not be able to invite an admin$/ do  
  Given "I am on the admin sign in page"
  page.should_not have_content('Send invitation')
  page.should have_content('Sign in')
end


Then /^I should not be able to create an administrator$/ do
  Given "I am on the admin sign up page"
  page.should have_content('You need to sign in or sign up before continuing.')
  page.should have_content('Sign in')
end


Then /^I should be able to invite an administrator$/ do
  fill_in 'First name', :with=>'John'
  fill_in 'Last name', :with=>'Doe'
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
