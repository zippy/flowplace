class CreateCurrencyWealLink < ActiveRecord::Migration
  def self.up
    create_table :currency_weal_links  do |t|
      t.integer :currency_id
      t.integer :weal_id
      t.text  :link_spec
    end
  end

  def self.down
    drop_table :currency_weal_links
  end
end
