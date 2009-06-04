class AddCurrencyAccountFields < ActiveRecord::Migration
  def self.up
  	add_column :currency_accounts, :player_class, :string
  	add_column :currency_accounts, :name, :string
  	rename_column :currency_accounts, :summary, :state
  end

  def self.down
  	rename_column :currency_accounts, :state, :summary
  	remove_column :currency_accounts, :player_class
  	remove_column :currency_accounts, :name
  end
end
