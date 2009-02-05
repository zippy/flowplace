class BoltToVersion4 < ActiveRecord::Migration
  def self.up
    Engines.plugins["bolt"].migrate(4)
  end

  def self.down
    Engines.plugins["bolt"].migrate(0)
  end
end
