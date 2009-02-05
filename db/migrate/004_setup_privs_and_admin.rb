class SetupPrivsAndAdmin < ActiveRecord::Migration
  def self.up    
    User::Permissions.each do |p|
      Permission.create(:name => p)
      r = Role.create!(:name => p)
      r.allowances.add(p)
    end

    admin = User.new(:user_name => 'admin', :first_name => 'The',:last_name => 'Administrator',:email=>'admin@host.com')
    if admin.create_bolt_identity(:password=>'admin',:user_name => :user_name,:enabled => true)
      admin.roles << Role.find(:all)
    end
  end
  
  def self.down
    Permission.destroy_all
    Role.destroy_all
    Allowance.destroy_all
    User.find(1).destroy
  end
end