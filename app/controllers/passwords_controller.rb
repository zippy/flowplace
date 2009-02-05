class PasswordsController < ApplicationController
  
  before_filter(:set_user,:except => [:index, :forgot, :edit, :update, :resetcode])

  private
  ################################################################################
  def set_user
    if logged_in?
      if params[:id]
        @user = User.find(params[:id])
      else
        params[:id] = current_user.id
        @user = current_user
      end
      if current_user_or_can?([:admin,:createAccounts])
        @identity = @user.bolt_identity
      end
    end
  end

  ################################################################################
  include(Bolt::BoltControllerMethods)
  
  ################################################################################
  # Rails 2.0 CSRF Security
  csrf_attack_prevention
  
end