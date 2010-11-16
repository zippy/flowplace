class AnnotationRevision < ActiveRecord::Base
  # we can accept the more standard hash syntax
  acts_as_revision :revisable_class_name => "Annotation"
end