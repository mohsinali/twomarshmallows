class ProfileController < ApplicationController
  before_action :authenticate_user!

  def toggle_activate
    @user = User.find_by(id: params[:id])    
    @user.is_active ^= true
    @user.save

    ## Notify teacher when his account is activated.
    TeacherMailer.account_activated(@user, Devise.friendly_token.first(6)).deliver_now if @user.is_active

    respond_to do |format|
      format.js
    end
  end
end
