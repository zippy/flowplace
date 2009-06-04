class CreatePlays < ActiveRecord::Migration
  def self.up
    create_table :plays do |t|
      t.integer :currency_account_id
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :plays
  end
end
