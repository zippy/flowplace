class CurrenciesAddAgreement < ActiveRecord::Migration
  def self.up
    remove_column :currencies, :summary
    add_column :currencies, :agreement, :text
  end

  def self.down
    remove_column :currencies, :agreement
    add_column :currencies, :summary, :integer
  end
end
