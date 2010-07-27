class RegistrationsController < ApplicationController
  prepend_before_filter :require_no_authentication, :only => [ :cancel ]
  prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy]
  prepend_before_filter :authenticate_admin_scope!, :only => [:new, :create]
  include Devise::Controllers::InternalHelpers

  # GET /resource/sign_up
  # GET /resource/sign_in
  def new
    build_resource
    render_with_scope :new
  end

  # POST /resource/sign_up
  def create
    build_resource

    if resource.save
      set_flash_message :notice, :signed_up
      sign_in_and_redirect(resource_name, resource)
    else
      render_with_scope :new
    end
  end

  # GET /resource/edit
  def edit
    render_with_scope :edit
  end

  # PUT /resource
  def update
    if self.resource.update_with_password(params[resource_name])
      set_flash_message :notice, :updated
      redirect_to after_sign_in_path_for(self.resource)
    else
      render_with_scope :edit
    end
  end

  # DELETE /resource
  def destroy
    self.resource.destroy
    set_flash_message :notice, :destroyed
    sign_out_and_redirect(self.resource)
  end

  protected

    # Authenticates the current scope and gets a copy of the current resource.
    # We need to use a copy because we don't want actions like update changing
    # the current user in place.
    def authenticate_scope!
      send(:"authenticate_#{resource_name}!")
      self.resource = resource_class.find(send(:"current_#{resource_name}").dup)
    end
    #hackety hack to allow only admins to create users/admins
    def authenticate_admin_scope!
      send(:"authenticate_admin!")
    end
end