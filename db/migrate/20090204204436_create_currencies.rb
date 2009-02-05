class CreateCurrencies < ActiveRecord::Migration
  def self.up
    create_table :currencies do |t|
      t.string :name
      t.boolean :global
      t.integer :circle_id

      t.timestamps
    end
  end

  def self.down
    drop_table :currencies
  end
end
