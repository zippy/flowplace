class HomeController < ApplicationController
  before_filter :set_current_circle,:only => :home
  helper :activities
  skip_before_filter :authenticate_user!, :only => [:logged_out,:home]
  def home
    if logged_in?
      @user = User.find(params[:user_id]) if params[:user_id]
      if @user
        @who = @user.first_name+"'s"
      else
        @who = 'My'
        @user = current_user
      end
      @currency_accounts_my = @user.currency_accounts_in_circle(@current_circle) if !@current_circle.nil?
      if @currency_accounts_my
        @currency_accounts_my = @currency_accounts_my.reject {|ca| ca.currency.is_a?(CurrencyMembrane)} unless current_user.has_preference('showMembranes') 
        #TODO: later we'll be more sophisticated about what player classes show on the left
        @currency_accounts_my = @currency_accounts_my.reject {|ca| !%w(member creator).include?(ca.player_class)}
        @currency_accounts_my = @currency_accounts_my.sort_by {|c| c.currency.name}
      end
      @currencies = @current_circle.currencies if @current_circle
      @currencies = @currencies.sort_by {|c| c.name} if @currencies
#      @currencies = Currency.find(:all)
    
      if Configuration.get(:wealing_policy) == 'on'
        @proposals_total_my = Proposal.count(:conditions=>["user_id = ?",@user.id])
        @proposals_total =  Proposal.count
   
        @intentions_total_my = @user.intentions.size
        @intentions_total =  Weal.count(:conditions=>"phase = 'intention'")

        @actions_total_my = @user.actions.size
        @actions_total =  Weal.count(:conditions=>"phase = 'actions'")
      end
    else
      render :action => :welcome
    end
  end

  def sys_info
    authorize! :read, :sys_info
    git_path = CONFIG[:git_path]
    git_path ||= '/usr/bin/git'
    @version = `#{git_path} describe`
    @git_log = `#{git_path} log -15`
    @current_database = ActiveRecord::Base.connection.current_database if ActiveRecord::Base.connection.respond_to?(:current_database)
  end

  def logged_out
  end

  def welcome
  end
  
  def close_banner
    session[:banner_closed] = true;
    redirect_to request.env['HTTP_REFERER']
  end
  
end
