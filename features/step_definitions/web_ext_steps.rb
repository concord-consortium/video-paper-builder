Given /^the following user records$/ do |table|
  @admins = []
  @users  = []
  table.hashes.each do |row|
    if row["role"] == "admin"
      @admins << {:email=>row["email"],:password=>row["password"]}
    else
      if row["role"] == "user"
        visit '/users/sign_up'
        fill_in 'Email', :with=> row["email"]
        fill_in 'Password', :with=> row["password"]
        fill_in 'Password confirmation', :with=> row["password"]
        click_button 'Sign up'
        user = User.find_by_email(row["email"])
        visit '/users/confirmation?confirmation_token=' + user.confirmation_token.to_s
        @users << {:email=>row["email"],:password=>row["password"]}
      end
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

Given /^I am logged in as the default user$/ do
  Given "I am not logged in"
  visit '/users/sign_in'
  fill_in 'Email', :with=>"fake_user@velir.com"
  fill_in 'Password', :with=>"funstuff"
  click_button 'Sign in'
end


Given /^I am not logged in$/ do
  visit '/admins/sign_out'
  visit '/users/sign_out'
end

Given /^I am an admin logged in as "([^\"]*)"$/ do |email|
  Given "I am not logged in"
  user_row  = @admins.map {|admin| admin if admin[:email] == email}
  visit '/admins/sign_in'
  fill_in 'Email', :with=> user_row.first[:email]
  fill_in 'Password', :with=>user_row.first[:password]
  click_button 'Sign in'
end

Given /^I am a user logged in as "([^\"]*)"$/ do |email|
  Given "I am not logged in"
  user_row  = @users.map {|user| user if user[:email] == email}
  visit '/users/sign_in'
  fill_in 'Email', :with=> user_row.first[:email]
  fill_in 'Password', :with=>user_row.first[:password]
  click_button 'Sign in'
end
