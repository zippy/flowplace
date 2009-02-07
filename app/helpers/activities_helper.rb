module ActivitiesHelper
  def find_activites(conditions=nil)
    options = {:limit=>10,:order => 'created_at DESC'}
    options[:conditions] = conditions if conditions
    Activity.find(:all,options)
  end
end
