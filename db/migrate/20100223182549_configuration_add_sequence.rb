class ConfigurationAddSequence < ActiveRecord::Migration
  def self.up
    add_column :configurations, :sequence, :string
    Configuration.merge_defaults
  end

  def self.down
    remove_column :configurations, :sequence
  end
end
