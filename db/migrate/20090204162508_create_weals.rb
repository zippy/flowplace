class CreateWeals < ActiveRecord::Migration
  def self.up
    create_table :weals do |t|
      t.string :title
      t.string :phase
      t.text :description
      t.integer :requester_id
      t.integer :fulfiller_id
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      
      t.timestamps
    end
  end

  def self.down
    drop_table :weals
  end
end
