class PasswordsController < ApplicationController
  prepend_before_filter :require_no_authentication
  include Devise::Controllers::InternalHelpers

  # GET /resource/password/new
  def new
    build_resource
    render_with_scope :new
  end

  # POST /resource/password
  def create
    @resources = User.send_reset_password_instructions(params[resource_name])

    self.resource = @resources.is_a?(Array) ? @resources[0] : @resources
    if resource.errors.empty?
      set_flash_message :notice, :send_instructions
      redirect_to new_session_path(resource_name)
    else
      render_with_scope :new
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    self.resource = resource_class.find_or_initialize_with_error_by(:reset_password_token, params[:reset_password_token])
    if resource.errors.empty?
      render_with_scope :edit
    else
      set_flash_message :notice, :invalid_reset_token
      redirect_to new_session_path(resource_name)
    end
  end

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(params[resource_name])

    if resource.errors.empty?
      set_flash_message :notice, :updated
      sign_in_and_redirect(resource_name, resource)
    else
      render_with_scope :edit
    end
  end
end
