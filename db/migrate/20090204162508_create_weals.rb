class CreateWeals < ActiveRecord::Migration
  def self.up
    create_table :weals do |t|
      t.string :title
      t.string :phase
      t.text :description
      t.integer :requester_id
      t.integer :offerer_id
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.boolean :created_by_requester, :null => false, :default => true
      
      t.timestamps
    end
  end

  def self.down
    drop_table :weals
  end
end
