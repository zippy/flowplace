class CreateWallets < ActiveRecord::Migration
  def self.up
    create_table :wallets do |t|
      t.string :name
      t.integer :user_id
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :wallets
  end
end
