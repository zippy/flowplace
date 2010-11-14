module ActivitiesHelper
  def find_activites(conditions=nil)
    options = {:limit=>10,:order => 'created_at DESC'}
    options[:conditions] = conditions if conditions
    activities = Activity.find(:all,options)
    activities = activities.reject {|a| a.is_a?(CurrencyActivity) && (c = a.activityable) && c.is_a?(CurrencyMembrane)}
  end
end
