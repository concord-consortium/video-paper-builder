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

Given /I perform javascript confirmation box magic$/ do
  page.evaluate_script('window.confirm = function() { return true; }')
end

When /^(?:|I )debug$/ do
  binding.pry
  0
end

Then /^I wait (\d+) seconds$/ do |seconds|
  sleep seconds.to_i
end
