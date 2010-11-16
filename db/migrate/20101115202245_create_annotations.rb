class CreateAnnotations < ActiveRecord::Migration
  def self.up
    create_table :annotations do |t|
      t.text :body
      t.string :path

      t.timestamps
    end
    %w(view_annotations edit_annotations admin_annotations).each do |p|
      if (!Permission.exists?(:name=>p))
        Permission.create(:name => p)
        r = Role.create!(:name => p)
        r.allowances.add(p)
      end
    end
  end

  def self.down
    drop_table :annotations
    %w(view_annotations edit_annotations admin_annotations).each do |p|
       p = Permission.find_by_name(p)
       p.destroy if p
       r = Role.find_by_name(p)
       r.destroy if r
    end
  end
end
