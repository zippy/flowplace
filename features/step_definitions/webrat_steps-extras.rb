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

