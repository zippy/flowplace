class Annotation < ActiveRecord::Base
  validates_presence_of :path
  validates_uniqueness_of :path
  acts_as_revisable do
    revision_class_name "AnnotationRevision"
    except :path
  end
  
  def Annotation.map_path(path,query)
    if path =~ /^\/currency_accounts\/([0-9]+)(.*?)$/
      (ca_id,extra) = [$1,$2]
      ca = CurrencyAccount.find(ca_id)
      path = "/currency_accounts/*#{ca.currency.name}*#{extra}"
    end
    path += '?'+query if !query.blank?
    path
  end    
end
