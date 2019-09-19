class ProfileController < ApplicationController
  before_action :authenticate_user!

  def toggle_activate
    @user           = User.find_by(id: params[:id])    
    @user.is_active ^= true
    password        = Devise.friendly_token.first(6)
    @user.password  = password
    @user.save

    ## Notify teacher when his account is activated.
    TeacherMailer.account_activated(@user, password).deliver_now if @user.is_active

    respond_to do |format|
      format.js
    end
  end
end
