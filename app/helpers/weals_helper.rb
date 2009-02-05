module WealsHelper
  include TagsHelper
  def render_name(which,weal)
    u = case which
    when :requester
      weal.requester
    when :fulfiller
      weal.fulfiller
    end
    u.nil? ? 'NA' : u.full_name
  end
end
