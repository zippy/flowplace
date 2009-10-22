def create_circle(name)
  Given %Q*a "Membrane" currency "#{name}"*
end

Given /^a circle "([^\"]*)"$/ do |circle_name|
  create_circle(circle_name)
end