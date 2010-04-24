class CreateCircleCurrencyPerissions < ActiveRecord::Migration
  def self.up    
    %w(circle currency).each do |p|
      if (!Permission.exists?(:name=>p))
        Permission.create(:name => p)
        r = Role.create!(:name => p)
        r.allowances.add(p)
      end
    end
  end
  
  def self.down
    %w(circle currency).each do |p|
      Permission.find_by_name(p).destroy
      Role.find_by_name(p).destroy
    end
  end
end
