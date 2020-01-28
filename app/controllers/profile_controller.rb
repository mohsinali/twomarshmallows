require "google/cloud/firestore"

class ProfileController < ApplicationController
  before_action :authenticate_user!
  before_action :set_fs_doc

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

    if @user.save
      if !@user.is_active
        @user.update_attribute(:jwt_token, nil)
        @doc_ref.set(is_active: false)
      else
        @doc_ref.set(is_active: true)
      end
    end

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

    if @user.save
      if !@user.is_active
        @user.update_attribute(:jwt_token, nil)
        @doc_ref.set(is_active: false)
      else
        @doc_ref.set(is_active: true)
      end
    end

    respond_to do |format|
      format.js
    end
  end

  private
    def set_fs_doc
      @firestore = Google::Cloud::Firestore.new credentials: ENV["FIREBASE_CREDENTIALS_PATH"]
      @doc_ref = @firestore.doc("user_status/#{params[:id]}")
    end
end

## on Signup is_approved=false is_active=false
## Set password if is_approved=false
## Set is_active=true & is_approved=true
