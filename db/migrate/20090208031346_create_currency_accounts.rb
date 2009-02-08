class CreateCurrencyAccounts < ActiveRecord::Migration
  def self.up
    add_column('currencies', 'type', :string)
    add_column('currencies', 'summary', :text)
    create_table :currency_accounts do |t|
      t.integer :user_id
      t.integer :currency_id
      t.text :summary

      t.timestamps
    end
  end

  def self.down
    drop_table :currency_accounts
    remove_column('currencies', 'type')
    remove_column('currencies', 'summary')
  end
end
