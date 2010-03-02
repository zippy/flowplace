Given "the default site configurations" do
  Configuration.restore_defaults
end

Given /^all configurations are deleted$/ do
  Configuration.destroy_all
end