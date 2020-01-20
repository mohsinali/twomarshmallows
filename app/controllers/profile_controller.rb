class ProfileController < ApplicationController
  before_action :authenticate_user!

  def toggle_activate
    @user           = User.find_by(id: params[:id])
    @user.toggle :is_active

    password  = ""
    profile   = @user.profile
    unless @user.profile.is_approved
      password            = Devise.friendly_token.first(6)
      @user.password      = password
      profile.is_approved = true
      profile.save
    end
    @user.save

    ## Notify teacher when his account is activated.
    if !password.blank?
      TeacherMailer.account_activated(@user, password).deliver_now if @user.is_active
    end

    respond_to do |format|
      format.js
    end
  end

  def toggle_activate_student
    @user = User.find_by(id: params[:id])
    @user.toggle :is_active
    @user.save

    respond_to do |format|
      format.js
    end
  end
end

## on Signup is_approved=false is_active=false
## Set password if is_approved=false
## Set is_active=true & is_approved=true
