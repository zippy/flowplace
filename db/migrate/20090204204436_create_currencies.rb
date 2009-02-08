class CreateCurrencies < ActiveRecord::Migration
  def self.up
    create_table :currencies do |t|
      t.string :name
      t.string :type
      t.boolean :global
      t.integer :circle_id
      t.integer :summary

      t.timestamps
    end
    create_table :currency_accounts do |t|
      t.integer :user_id
      t.integer :currency_id
      t.text :summary

      t.timestamps
    end
  end

  def self.down
    drop_table :currency_accounts
    drop_table :currencies
  end
end
