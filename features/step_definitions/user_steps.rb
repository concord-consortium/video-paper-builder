Given /^the administrator "([^"]*)" invites a user "([^"]*)"$/ do |admin, user|
  Given "I am an admin logged in as \"#{admin}\""
  When "I go to the user invitation page"
  with_scope("#body_container") do
    fill_in 'Email', :with=>user
    fill_in 'First name', :with=> "John"
    fill_in 'Last name', :with=> "Doe"
    click_button 'Invite'
  end
end

Given /^the following user records$/ do |table|
  @admins = []
  @users  = []
  table.hashes.each do |row|
    if row["role"] == "admin"
      @admins << {:email=>row["email"]}
      FactoryGirl.create(:admin, :email=>row["email"])
    elsif row["role"] == "user"
      @users << {:email=>row["email"]}

      if(row["confirmed"])
        confirmed = ["yes", "true"].include? row["confirmed"].downcase
      else
        confirmed = true
      end

      if confirmed
        FactoryGirl.create(:user, :email=>row["email"])
      else
        FactoryGirl.create(:invited_user, :email=>row["email"])
      end
    end
  end
end

Given /^I am a user logged in as "([^\"]*)"$/ do |email|
  @current_user = User.find_by_email email
  visit "/login_for_test/#{@current_user.id}"
end

Given /^I am not logged in$/ do
  visit destroy_admin_session_path
  visit destroy_user_session_path
end

Given /^I am an admin logged in as "([^\"]*)"$/ do |email|
  Given "I am not logged in"
  user_row  = @admins.map {|admin| admin if admin[:email] == email}
  user_row = user_row.first
  visit '/admins/sign_in'
  @current_admin = Admin.find_by_email user_row[:email]
  @current_admin.should_not be_nil
  with_scope("#body_container") do
    fill_in 'Email', :with=> user_row[:email]
    fill_in 'Password', :with=> 'funstuff'
    click_button 'Sign in'
  end
  page.should have_content("Admin Console")
end

# this is the interactive way
Given /^I am a old user logged in as "([^\"]*)"$/ do |email|
  Given "I am not logged in"
  user_row  = @users.map {|user| user if user[:email] == email}
  visit '/users/sign_in'
  with_scope("#body_container") do
    fill_in 'Email', :with=> email
    fill_in 'Password', :with=> 'funstuff'
    click_button 'Sign in'
  end
end

Given /^I am the admin "([^\"]*)" and I create the following user:$/ do |email, table|
  @users ||= []
  Given "I am not logged in"
  Given "I am an admin logged in as \"#{email}\""
  table.hashes.each do |row|
    When "I go to the user sign up page"
    fill_in 'Email', :with=> row["email"]
    fill_in 'Password',:with=>row["password"]
    fill_in 'Password confirmation', :with=> row["password"]
    click_button 'Sign up'
    Given "I am not logged in"
    When "I go to the #{row["email"]}'s user confirmation page"
    @users << {:email=>row["email"],:password=>row["password"]}
  end
  Given "I am not logged in"
end
