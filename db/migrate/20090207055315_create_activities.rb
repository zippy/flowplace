class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.integer :user_id
      t.string :type
      t.string :activityable_type
      t.integer :activityable_id
      t.text :contents

      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
