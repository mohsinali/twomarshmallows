class AdminController < ApplicationController
  before_action :authenticate_user!, :authorize_admin
  before_action :set_user, only: [:edit, :update]

  def index
    @users = User.all    
  end

  def new
    @user = User.new
  end

  def edit    
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to admin_index_path, notice: 'User was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def create
    @user = User.new(user_params)
    
    respond_to do |format|
      if @user.save        
        UserMailer.new_user_account(@user, user_params[:password]).deliver_now
        format.html { redirect_to admin_index_path, notice: 'User was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  private
    def user_params
      if params[:user][:password].blank?
        params.fetch(:user, {}).permit(:name, :email)
      else
        params.fetch(:user, {}).permit(:name, :email, :password)
      end
    end

    def set_user
      @user = User.friendly.find(params[:id])
    end
end
