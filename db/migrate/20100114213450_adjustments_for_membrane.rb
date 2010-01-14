class AdjustmentsForMembrane < ActiveRecord::Migration
  def self.up
    remove_column :currencies, :circle_id
    remove_column :currencies, :global
    drop_table :circle_user_links
    drop_table :circles
  end

  def self.down
    add_column :currencies, :circle_id, :integer
    add_column :currencies, :global, :boolean
    create_table :circles do |t|
      t.string :name

      t.timestamps
    end
    create_table :circle_user_links  do |t|
      t.integer :user_id
      t.integer :circle_id
      t.string  :link_type
    end
  end

end
