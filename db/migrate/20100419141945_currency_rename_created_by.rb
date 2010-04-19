class CurrencyRenameCreatedBy < ActiveRecord::Migration
  def self.up
    change_table :currencies do |t|
      t.rename(:created_by, :steward_id)
    end
  end

  def self.down
    change_table :currencies do |t|
      t.rename(:steward_id, :created_by)
    end
  end
end
