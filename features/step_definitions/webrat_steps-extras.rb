Then /^I should( not)* see the "([^\"]*)" image$/ do |should_not,url|
  images = response.body.scan(/<img.*?src="(.*?)\?*[0-9]*"/).flatten
  has_img = images.include?(url)
  if should_not
    has_img.should_not be_true
  else
    has_img.should be_true
  end
end

Then /^I should( not)* see an image with title "([^\"]*)"$/ do |should_not,title|
  images = response.body.scan(/<img.*?title="(.*?)"/m).flatten
  has_img = images.include?(title)
  if should_not
    has_img.should_not be_true
  else
    has_img.should be_true
  end
end

Then /^I should( not)* see a tag "([^\"]*)"$/ do |should_not,tag|
  if should_not
    response.should_not have_tag(tag)
  else
    response.should have_tag(tag)
  end
end

Then /^I should see "([^\"]*)" as a "([^\"]*)" option$/ do |value, field|
  lambda {select(value, :from => field)}.should_not raise_error
end

Then /^I should not see "([^\"]*)" as a "([^\"]*)" option$/ do |value, field|
  lambda {select(value, :from => field)}.should raise_error
end

Then /^I should see link with title "([^\"]*)"$/ do |title|
  response.should have_tag('a','title'=>title)
end

When /^(?:|I )select "([^\"]*)" from "([^\"]*)" within "([^\"]*)"$/ do |value, field, selector|
  within(selector) do |content|
    select(value, :from => field)
  end
end


When /^(?:|I )press "([^\"]*)" within "([^\"]*)"$/ do |button,selector|
  within(selector) do |content|
    click_button(button)
  end
end

Then /^"([^"]*)" should be selected for "([^"]*)"$/ do |value, field|
  field_labeled(field).element.search(".//option[@selected = 'selected']").inner_html.should =~ /#{value}/
end