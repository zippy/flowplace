class CreateConfigurations < ActiveRecord::Migration
  def self.up
    create_table :configurations do |t|
      t.string :name
      t.string :configuration_type
      t.text :value
      t.text :description

      t.timestamps
    end
    Configuration.restore_defaults
  end

  def self.down
    drop_table :configurations
  end
end
