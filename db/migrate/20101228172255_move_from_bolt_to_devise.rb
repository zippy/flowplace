module DeviseUpdate
  def database_authenticatable(options={})
    null    = options[:null] || false
    default = options[:default] || ""

    apply_schema :encrypted_password, String, :null => null, :default => default, :limit => 128
    apply_schema :password_salt,      String, :null => null, :default => default
  end
  module ActiveRecord
    include DeviseUpdate
  end
end

ActiveRecord::ConnectionAdapters::Table.send :include, DeviseUpdate::ActiveRecord
ActiveRecord::ConnectionAdapters::TableDefinition.send :include, DeviseUpdate::ActiveRecord

class MoveFromBoltToDevise < ActiveRecord::Migration
  def self.up    
    change_table(:users) do |t|
      t.database_authenticatable :null => false
      t.confirmable
      t.recoverable
      t.rememberable
    end
    rename_column(:users, :last_login, :last_sign_in_at)
    rename_column(:users, :last_login_ip, :last_sign_in_ip)
    add_column :users,:sign_in_count, :integer, :default => 0
    add_column :users,:current_sign_in_at, :datetime
    add_column :users,:current_sign_in_ip, :string

    add_index :users, :confirmation_token,   :unique => true
    add_index :users, :reset_password_token, :unique => true
    User.reset_column_information
    User.all.each do |user|
      user.confirm!
    end
  end

  def self.down
    remove_index :users, :confirmation_token
    remove_index :users, :reset_password_token
    
    remove_column :users,"password_salt"
    remove_column :users,"confirmation_token"
    remove_column :users,"confirmed_at"
    remove_column :users,"confirmation_sent_at"
    remove_column :users,"reset_password_token"
    remove_column :users,"remember_token"
    remove_column :users,"remember_created_at"
    remove_column :users,"sign_in_count"
    remove_column :users,"current_sign_in_at"
    remove_column :users,"current_sign_in_ip"
    rename_column(:users, :last_sign_in_at, :last_login)
    rename_column(:users, :last_sign_in_ip, :last_login_ip)    
    remove_column :users,"encrypted_password"
  end
end
