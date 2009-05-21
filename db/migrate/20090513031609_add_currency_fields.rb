class AddCurrencyFields < ActiveRecord::Migration
  def self.up
  	add_column :currencies, :icon_url, :string
  	add_column :currencies, :symbol, :string
  	add_column :currencies, :description, :text
  end

  def self.down
  	remove_column :currencies, :icon_url
  	remove_column :currencies, :symbol
  	remove_column :currencies, :description
  end
end
