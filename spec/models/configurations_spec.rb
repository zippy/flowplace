require File.dirname(__FILE__) + '/../spec_helper'

describe Configuration do
  before(:each) do
    @configuration = Configuration.new
  end

  it "should be valid" do
    @configuration.should be_valid
  end
  
  it "should be able to restore defaults" do
    Configuration.restore_defaults
    config_yaml = YAML::load(IO.read(RAILS_ROOT + '/app/models/configuration_defaults.yml'))
    Configuration.all.size.should == config_yaml.size
    Configuration.restore_defaults
    Configuration.all.size.should == config_yaml.size
  end
  
  it "merges in new configurations automatically" do
    Configuration.create({
      'name' => 'site_name',
      'value' => 'Cool Site',
      'sequence' => '2',
      'configuration_type' => 'string'
    })
    Configuration.merge_defaults
    c = Configuration.find_by_name('site_name')
    c.value.should == 'Cool Site'
    c.sequence.should == '1'
    config_yaml = YAML::load(IO.read(RAILS_ROOT + '/app/models/configuration_defaults.yml'))
    Configuration.all.size.should == config_yaml.size
  end
end
