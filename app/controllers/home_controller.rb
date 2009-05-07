class HomeController < ApplicationController
  helper :activities
  require_authentication :except => :logged_out
  require_authorization :admin,:only => :version
  def home
    @user = User.find(params[:user_id]) if params[:user_id]
    if @user
      @who = @user.first_name+"'s"
    else
      @who = 'My'
      @user = current_user
    end
    
    @currency_accounts_my = @user.currency_accounts
    @currencies = Currency.find(:all)
    
    @proposals_total_my = Proposal.count(:conditions=>["user_id = ?",@user.id])
    @proposals_total =  Proposal.count
   
    @intentions_total_my = @user.intentions.size
    @intentions_total =  Weal.count(:conditions=>"phase = 'intention'")

    @projects_total_my = @user.projects.size
    @projects_total =  Weal.count(:conditions=>"phase = 'project'")
  end

  def sys_info
    @version = `/usr/local/bin/git describe`
    @git_log = `/usr/local/bin/git log -15`
    @current_database = ActiveRecord::Base.connection.current_database if ActiveRecord::Base.connection.respond_to?(:current_database)
  end

  def logged_out
  end

  def admin
  end
  
end
