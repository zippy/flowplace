# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
include Lister

SearchPairs = [['a','user_name'],['m',SQL_FULL_NAME],['f','first_name'], ['l','last_name'], ['e','email'],['s','state'],['n','notes']]
OrderPairs = [
  ['a','user_name'],
  ['n','last_name,first_name'],
  ['ll','last_login desc'],
  ['c','created_at desc'],
  ['i','id']
]
SearchFormParams = {
  :order_choices => [
    ['Name','n'],
    ['Account name','a'],
    ['Account ID','i'],
    ['Last Login','ll'],
    ['Account Created','c']
    ],
  :select_options => {
    'main' => [
      ['Full name contains','m_c'],
      ['Full name begins with','m_b'],
      ['Account name contains','a_c'],
      ['Account name begins with','a_b'],
      ['E-mail contains','e_c'],
      ['E-mail begins with','e_b'],
      ['State/province abbrev. is', 's_is'],
      ['Notes contain','n_c'],
      ['Show all','all']]
    },
  :search_pair_info => [{:name => "main", :on => :select, :for => :text_field, :first_focus => true}]
}

class ApplicationController < ActionController::Base
  require_authentication
  helper :all # include all helpers, all the time
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
#  protect_from_forgery :secret => 'b97ae5e625966e6c6aab11ea53aeabc4'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  def rescue_action_in_public(exception)
    @exception = exception.to_s
    render :file => "#{RAILS_ROOT}/public/500_active.html",:layout=>true, :status => 500
  end
  
  def current_user_or_can?(permissions = nil,obj = nil)
    the_id = obj ? obj.user_id : params[:id].to_i
    permissions = [permissions] if !permissions.nil? && permissions.class != Array
    if (the_id == current_user.id) || (!permissions || (permissions.any? {|p| current_user.can?(p)} ) )
      true
    else
      respond_to do |format|
        flash[:notice] = :not_allowed
        format.html { redirect_to( home_url) }
        format.xml  { head :failure }
      end
      false
    end
  end

  def access_denied
    flash[:notice] = :not_allowed
    redirect_to(home_url)
  end

  private

  ################################################################################
  include(Bolt::BoltControllerMethods)
  
end
