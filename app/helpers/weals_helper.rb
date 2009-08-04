module WealsHelper
  include TagsHelper
  def render_name(which,weal)
    u = case which
    when :requester
      weal.requester
    when :offerer
      weal.offerer
    end
    if u.nil?
      'NA'
    else
     gravitar_image_tag(u,:size=>20)+u.full_name
   end
  end

  def render_as(weal)
    case
    when weal.requester == current_user
      'requester'
    when weal.offerer == current_user
      'offerer'
    when p = weal.proposals.detect {|p| p.user_id == current_user.id ? p.as : false }
      "proposed #{p.as}"
    else
      "NA"
    end
  end

  def render_weals_tag_cloud(options={})
    tags = Weal.tag_counts(options)
    if tags.empty?
      ''
    else
      result = []
      tag_cloud tags, %w(css1 css2 css3 css4) do |tag, css_class|
        result << link_to( tag.name, { :action => :tag, :id => tag.name }, :class => css_class)
      end
      result.join(' ')
    end
  end

  def options_for_select_in_service_of
    users = User.find(:all,:conditions => 'circle_id is null',:order => 'last_name,first_name')
    circles = Circle.find(:all,:order => 'name')
    [['-unspecified-',nil],['-any-','-any-'],['-commons-','-commons-']] + circles.collect{|c| [c.name, c.user_account.blank? ? c.name : c.user_account.id]} + users.collect{|u| [u.full_name,u.id]}
  end

end
