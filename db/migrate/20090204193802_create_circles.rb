class CreateCircles < ActiveRecord::Migration
  def self.up
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

  def self.down
    drop_table :circle_user_links
    drop_table :circles
  end
end
