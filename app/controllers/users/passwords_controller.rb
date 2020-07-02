# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  layout "main/layout-blank"
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  def create
    email = params[:user][:email].downcase
    user  = User.find_by(email: email)
    if !user.nil? && user.has_role?(:superadmin)
      super
    else
      respond_to do |format|
        format.html { redirect_to new_password_path('user'), notice: 'Only admin can perform this action.' }
      end
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  def update
    super
  end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
