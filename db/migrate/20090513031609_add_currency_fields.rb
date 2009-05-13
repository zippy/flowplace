class AddCurrencyFields < ActiveRecord::Migration
  def self.up
  	add_column :currencies, :icon_url, :string
  	add_column :currencies, :symbol, :string
  end

  def self.down
  	remove_column :currencies, :icon_url
  	remove_column :currencies, :symbol
  end
end
