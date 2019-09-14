class ProfileController < ApplicationController
  before_action :authenticate_user!

  def toggle_activate
    @user = User.find_by(id: params[:id])    
    @user.is_active ^= true
    @user.save

    respond_to do |format|
      format.js
    end
  end
end
