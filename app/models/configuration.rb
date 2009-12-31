class Configuration < ActiveRecord::Base
  Types = %w(options string text)
  def Configuration.get(config_name)
    c = Configuration.find_by_name(config_name.to_s)
    c.value if c
  end
  
  def Configuration.load_defaults
    config = YAML::load(IO.read(File.dirname(__FILE__) + '/configuration_defaults.yml'))
    config.each do |name,values|
      c = Configuration.new(values)
      c.save!
    end
  end
  
end
