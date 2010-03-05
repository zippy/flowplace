class AddPlayCurrencyAccountLink < ActiveRecord::Migration
  def self.up
    create_table :play_currency_account_links  do |t|
      t.integer :currency_account_id
      t.integer :play_id
      t.string  :field_name
    end
    remove_column :plays, :currency_account_id
  end

  def self.down
    drop_table :play_currency_account_links
    add_column :plays, :currency_account_id, :integer
  end
end
