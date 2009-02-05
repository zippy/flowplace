Given /I am on the new intentions page/ do
  visit "/weals/new"
end

Given /^the following froobles:$/ do |froobles|
  Frooble.create!(froobles.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) frooble$/ do |pos|
  visit froobles_url
  within("table > tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /I should be take to the intentions list/ do
  request.env["REQUEST_URI"].should == '/weals'
end


Then /^I should see the following froobles:$/ do |froobles|
  froobles.raw[1..-1].each_with_index do |row, i|
    row.each_with_index do |cell, j|
      response.should have_selector("table > tr:nth-child(#{i+2}) > td:nth-child(#{j+1})") { |td|
        td.inner_text.should == cell
      }
    end
  end
end
