class CircleChanges < ActiveRecord::Migration
  def self.up
    add_column :weals, :in_service_of, :text
    add_column :users, :circle_id, :integer
    add_column :circles, :description, :text
  end

  def self.down
    remove_column :weals, :in_service_of
    remove_column :users, :circle_id
    remove_column :circles, :description
  end
end
