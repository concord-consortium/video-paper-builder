sections = [ 'introduction', 'lesson', 'student_work', 'results', 'conclusion' ]

Then /^I should have five sections$/ do
  sections.each{|section| 
    page.should have_css("##{section}")
  }
end

Then /^the (.+) tab should be current$/ do |current_tab|  
  sections.each{|section|
    css = "##{section}_tab.ui-tabs-selected"
    if current_tab == section
      page.should have_css(css)
    else
      page.should_not have_css(css)
    end    
  }
end

Then /^I share "([^"]*)" with "([^"]*)"$/ do |paper, user|
  step "I go to #{paper}'s sharing page"
  step "I should see \"Sharing Settings for #{paper}\""
  fill_in 'shared_paper_user_id', :with=> user
  step "I press \"Share\""
end

Then /^I unshare "([^"]*)" with "([^"]*)"$/ do |paper, user|
  step "I go to #{paper}'s sharing page"
  step "I should see \"Sharing Settings for #{paper}\""
  click_link_or_button("unshare")
end

When /^I add "([^"]*)" to "([^"]*)"$/ do |content,finder|
  ##
  # This is probably the biggest hackety hack of the entire project.
  # The WYSIWYG editor drops an iframe and hides the section content text field, and then 
  # through dark magic populates it via the iframes' body inner html.  So thats what this
  # does.  Didn't want to throw out the tests.
  #
  page.evaluate_script("document.getElementById(\"#{finder}\").contentWindow.document.body.innerHTML = \"#{content}\";") 
end


