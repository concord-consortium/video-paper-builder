Given /^the following user records$/ do |table|
  @admins = []
  @users  = []
  table.hashes.each do |row|
    if row["role"] == "admin"
      @admins << {:email=>row["email"],:password=>row["password"]}
    elsif row["role"] == "user"
      @users << {:email=>row["email"],:password=>row["password"]}
    end
  end
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
  fill_in 'Email', :with=> email
  fill_in 'Password', :with=> 'funstuff'
  click_button 'Sign in'
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

Given /^the following video papers$/ do |table|
  @papers = []
  table.hashes.each do |row|
    @papers << {:title => row["title"],:user=>row["user"]}
  end
end

Given /^the following videos$/ do |table|
end

Then /^(?:|I )should not be on (.+)$/ do |page_name|
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should_not == path_to(page_name)
  else
    assert_not_equal path_to(page_name), current_path
  end
end