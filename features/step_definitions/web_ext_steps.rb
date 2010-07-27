Given /^the following user records$/ do |table|
  Given "I am logged in as the default administrator"
  @admins = []
  table.hashes.each do |row|
    if row["role"] == "admin"
      visit '/admins/sign_up'
      fill_in 'Email', :with=> row["email"]
      fill_in 'Password', :with=> row["password"]
      fill_in 'Password confirmation', :with=> row["password"]
      click_button 'Sign up'
      admin = Admin.find_by_email(row["email"])
      visit '/admins/confirmation?confirmation_token=' + admin.confirmation_token.to_s
      @admins << {:email=>row["email"],:password=>row["password"]}
    else
    end
  end
end

Given /^I am logged in as the default administrator$/ do
  Given "I am not logged in"
  visit '/admins/sign_in'
  fill_in 'Email', :with=>"videopaperbuilder@gmail.com"
  fill_in 'Password', :with=>"funstuff"
  click_button 'Sign in'
end

Given /^I am not logged in$/ do
  visit '/admins/sign_out'
end

Given /^I am logged in as "([^\"]*)"$/ do |email|
  Given "I am not logged in"
  user_row  = @admins.map {|admin| admin if admin[:email] == email}
  visit '/admins/sign_in'
  fill_in 'Email', :with=> user_row.first[:email]
  fill_in 'Password', :with=>user_row.first[:password]
  click_button 'Sign in'
end
