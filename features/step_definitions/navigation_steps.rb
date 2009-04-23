Then "$actor should be taken to (.*)" do |actor,page|
  request.env["REQUEST_URI"].should == path_to(page)
end