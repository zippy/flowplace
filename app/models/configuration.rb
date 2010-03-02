class Configuration < ActiveRecord::Base
  validates_uniqueness_of :name
  Types = %w(options string text yaml)

  def validate
    begin
      YAML.load(value) if !value.blank?
    rescue
      errors.add(:value,"must be valid YAML")
    end
  end

  def Configuration.get(config_name)
    c = Configuration.find_by_name(config_name.to_s)
    c.value if c
  end
  
  def Configuration.load_defaults
    YAML::load(IO.read(File.dirname(__FILE__) + '/configuration_defaults.yml'))
  end
    
  def Configuration.restore_defaults
    defaults = load_defaults
    Configuration.destroy_all
    defaults.keys.sort.each do |name|
      values = defaults[name]
      c = Configuration.new(values)
      if c.respond_to?(:sequence)
        (x,sequence) = name.split('_',2)
        values['sequence'] = sequence
      end
      c.save!
    end
  end
  
  def Configuration.merge_defaults
    defaults = load_defaults
    defaults.keys.sort.each do |name|
      (x,sequence) = name.split('_',2)
      values = defaults[name]
      values['sequence'] = sequence
      c = Configuration.find_by_name(values['name'])
      if c.nil?
        Configuration.create(values)
      else
        c.sequence = sequence
        c.save!
      end
    end
  end
  
end
