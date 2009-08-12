class CurrenciesAddFields < ActiveRecord::Migration
  def self.up
    remove_column :currencies, :summary
    add_column :currencies, :agreement, :text
    add_column :currencies, :config, :text
  end

  def self.down
    remove_column :currencies, :config
    remove_column :currencies, :agreement
    add_column :currencies, :summary, :integer
  end
end
