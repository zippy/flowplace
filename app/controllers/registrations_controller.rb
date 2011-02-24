class RegistrationsController < ApplicationController
  prepend_before_filter :require_no_authentication, :only => [ :new, :create ]
  prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy]
  include Devise::Controllers::InternalHelpers

  # GET /resource/sign_in
  def new
    authorize! :self_signup, :all
    build_resource
    render_with_scope :new
  end

  # POST /resource/sign_up
  def create
    build_resource
    return if !self_signup_ok?

    if resource.save
      flash[:notice] = "The account #{resource.user_name} has been created and activation instructions were sent to #{resource.email}"
#      set_flash_message :notice, :signed_up
      sign_in_and_redirect(resource_name, resource)
    else
      render_with_scope :new
    end
  end

  # GET /resource/edit
  def edit
    return if !self_signup_ok?
    render_with_scope :edit
  end

  # PUT /resource
  def update
    return if !self_signup_ok?
    if self.resource.update_with_password(params[resource_name])
      set_flash_message :notice, :updated
      redirect_to after_sign_in_path_for(self.resource)
    else
      render_with_scope :edit
    end
  end

  # DELETE /resource
  def destroy
    return if !self_signup_ok?
    self.resource.destroy
    set_flash_message :notice, :destroyed
    sign_out_and_redirect(self.resource)
  end

  protected
    def self_signup_ok?
      if Configuration.get(:new_user_policy) != 'self_signup'
        redirect_to home_url
        false
      else
        true
      end
    end

    # Authenticates the current scope and dup the resource
    def authenticate_scope!
      send(:"authenticate_#{resource_name}!")
      self.resource = send(:"current_#{resource_name}").dup
    end
end