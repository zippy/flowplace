class CurrenciesAddCreatedBy < ActiveRecord::Migration
  def self.up
    add_column :currencies, :created_by, :integer
    Currency.find(:all).each {|c| c.created_by = 1;c.save};
  end

  def self.down
    remove_column :currencies, :created_by
  end
end
