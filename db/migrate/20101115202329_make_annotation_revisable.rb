class MakeAnnotationRevisable < ActiveRecord::Migration
  def self.up
        add_column :annotations, :revisable_original_id, :integer
        add_column :annotations, :revisable_branched_from_id, :integer
        add_column :annotations, :revisable_number, :integer
        add_column :annotations, :revisable_name, :string
        add_column :annotations, :revisable_type, :string
        add_column :annotations, :revisable_current_at, :datetime
        add_column :annotations, :revisable_revised_at, :datetime
        add_column :annotations, :revisable_deleted_at, :datetime
        add_column :annotations, :revisable_is_current, :boolean
      end

  def self.down
        remove_column :annotations, :revisable_original_id
        remove_column :annotations, :revisable_branched_from_id
        remove_column :annotations, :revisable_number
        remove_column :annotations, :revisable_name
        remove_column :annotations, :revisable_type
        remove_column :annotations, :revisable_current_at
        remove_column :annotations, :revisable_revised_at
        remove_column :annotations, :revisable_deleted_at
        remove_column :annotations, :revisable_is_current
      end
end
