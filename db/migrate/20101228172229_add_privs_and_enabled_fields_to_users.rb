class AddPrivsAndEnabledFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column('users', 'privs', :text)
    add_column('users', 'enabled', :boolean)
    User.reset_column_information
    User.all.each do |user|
      user.privs = user.roles.collect {|r| r.name}.to_yaml
      user.enabled = user.bolt_identity.enabled? if user.bolt_identity_id
      user.save
    end
  end

  def self.down
    remove_column('users', 'privs')
    remove_column('users', 'enabled')
  end
end
