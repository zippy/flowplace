def shouldify(should)
  method = (should == "should" ? :should : :should_not)
end
