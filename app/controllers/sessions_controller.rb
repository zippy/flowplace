################################################################################
# overriding the create method of this controller to save an event to the event 
# log if log-in fails

class SessionsController < ApplicationController
  ################################################################################
  # Log the user in, redirecting to the correct page.
  def create
    backend = Bolt::Config.backend_class

    if identity = backend.authenticate(params[:login], params[:password])
      login(identity.user_model_object) and return
    else
#      Event.create(:user_id=>self.id,:event_type=>'login',:sub_type =>"failed",:content => "#{request.remote_ip}; login: #{params[:login]}")
    end

    @login_error = "The credentials you entered are incorrect, please try again."
    render(:action => :new)
  end

  private
  ################################################################################
  include(Bolt::BoltControllerMethods)
  
  ################################################################################
  # Rails 2.0 CSRF Security
  csrf_attack_prevention
end