require "google/cloud/firestore"

class Api::V1::UsersController < Api::V1::ApiController
  include Api::V1::UsersHelper
  skip_before_action :authenticate_via_token, only: [:signin, :signup, :profile, :forgot_password, :resetpassword ]

  #####################################################################
  ## Function:    signin
  ## Endpoint:    [POST]/users/signin
  ## Params:      @email
  ##              @password
  #####################################################################
  def signin
    email     = params[:email].downcase
    password  = params[:password]

    #  Check required params
    ## Email & password is required
    if email.blank? || password.blank?
      return render json: { success: false, msg: 'Email and Password is required.' }, status: 200
    end

    # Fetch user by email
    @user = User.find_by(email: email)
    return render json: { success: false, msg: 'Invalid email / password.' }, status: 200 unless @user

    # Check if user is active
    return render json: { success: false, msg: "Sorry! Can't allow you to log in for the moment." }, status: 200 unless @user.is_active

    ## User found, check password and proceed
    if @user.valid_password?(password)
      token = @user.get_jwt_token()

      ## Update user with token
      @user.update_attribute(:jwt_token, token)

    else
      return render json: { success: false, msg: 'Invalid email / password.' }, status: 200
    end
  end

  #####################################################################
  ## Function:    signup
  ## Endpoint:    [POST]/users/signup
  ## Params:      @email
  #####################################################################
  def signup
    email           = params[:user][:email]
    password        = Devise.friendly_token.first(8)
    @user           = User.new(email: email.downcase, password: password)
    @user.is_active = false

    if email.blank?
      return render json: { success: false, msg: 'Email address is required.' }, status: 200
    end

    if @user.save
      @user.add_role :teacher

      # Adding user_status on firebase w.r.t user id

      firestore = Google::Cloud::Firestore.new credentials: ENV["FIREBASE_CREDENTIALS_PATH"]
      doc_ref = firestore.doc("user_status/#{@user.id}")
      doc_ref.set(is_active: true)

      @user.create_profile(profile_params)

      ## Notify admin
      UserMailer.new_signup(@user).deliver_now
      UserMailer.new_teacher_notify(@user).deliver_now

      return render json: {success: true, msg: 'User created successfully.', data: { id: @user.id, email: email}}, status: 200
    else
      return render json: { success: false, msg: 'Sorry! the email address already exists.' }, status: 200
    end
  end

  #####################################################################
  ## Function:    forgotpassword
  ## Endpoint:    [POST]/users/forgotpassword
  ## Params:      @email
  ## Description: If email is verified, reset password email with token is sent to user.
  #####################################################################
  def forgot_password
    email = params[:email]
    url = params[:callback_url]
    #  Check required params
    ## Email is required
    if email.blank?
      return render json: { success: false, msg: 'Email is required.' }, status: 200
    end

    # Fetch user by email
    @user = User.where(email: email)
    if !@user.any?
      return render json: { success: false, msg: 'Email not found.' }, status: 200
    end
    @user = @user.first
    raw, hashed = Devise.token_generator.generate(User, :reset_password_token)
    @user.reset_password_token = hashed
    @user.reset_password_sent_at = Time.now.utc
    @user.save
    UserMailer.forgot_password(@user, hashed, url).deliver_now
    return render json: { success: true, msg: 'Reset password email has been sent.' }, status: 200
  end


  #####################################################################
  ## Function:    resetpassword
  ## Endpoint:    [POST]/users/resetpassword
  ## Params:      @token
  ##              @password
  ## Description: If token is matched, password is updated
  #####################################################################
  def resetpassword
    token = params[:token]
    password = params[:password]

    #  Check required params
    ## Token is required
    if token.blank? || password.blank?
      return render json: { success: false, msg: 'Token and Password is required.' }, status: 200
    end

    # Fetch user by token
    @user = User.find_by(reset_password_token: token)
    if @user
      @user.password = password
      @user.reset_password_token = nil
      @user.save
      return render json: { success: true, msg: 'Password reset successfully.' }, status: 200
    else
      return render json: { success: false, msg: 'Invalid token.' }, status: 200
    end
  end


  #####################################################################
  ## Function:    update_password
  ## Endpoint:    [POST]/users/update_password
  ## Params:      @current_password
  ##              @new_password
  ##
  ## Description: It will update the user's password in database by verifying the current password.
  #####################################################################
  def update_password
    current_password  = params[:current_password]
    new_password      = params[:new_password]

    if current_password.blank? || new_password.blank?
      return render json: { success: false, msg: 'Current password is required.' }, status: 200
    end

    if @user.valid_password?(current_password)
      @user.password = new_password
      @user.save!

      return render json: { success: true, msg: 'Password updated sucessfully.' }, status: 200
    else
      return render json: { success: false, msg: 'Current password is not valid.' }, status: 200
    end

  end

  def signout
    @user.update_logout_details()

    return render json: { success: true, msg: 'You have been logged out successfully.' }, status: 200
  end

  def profile
    @person = User.find(params[:id].to_i)
    return render json: {success: false, msg: 'Invalid user id.'} unless @person
  end

  private
    def profile_params
      params.fetch(:user, {}).permit(:full_name, :organization, :phone)
    end
end
