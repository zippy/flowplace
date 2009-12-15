class AddWealCircle < ActiveRecord::Migration
  def self.up
    add_column :weals, :circle_id, :integer
  end

  def self.down
    remove_column :weals, :circle_id
  end
end
