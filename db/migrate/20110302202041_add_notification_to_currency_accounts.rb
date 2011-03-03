class AddNotificationToCurrencyAccounts < ActiveRecord::Migration
  def self.up
    add_column :currency_accounts, :notification, :string
  end

  def self.down
    remove_column :currency_accounts, :notification
  end
end
