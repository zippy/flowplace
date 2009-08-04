class WealsAddNotes < ActiveRecord::Migration
  def self.up
    add_column :weals, :notes, :text
  end

  def self.down
    remove_column :weals, :notes
  end
end
