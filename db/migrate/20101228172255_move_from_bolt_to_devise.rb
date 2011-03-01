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
      t.trackable
    end

    add_index :users, :confirmation_token,   :unique => true
    add_index :users, :reset_password_token, :unique => true
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
    remove_column :users,"last_sign_in_at"
    remove_column :users,"current_sign_in_ip"
    remove_column :users,"last_sign_in_ip"
    remove_column :users,"encrypted_password"
  end
end