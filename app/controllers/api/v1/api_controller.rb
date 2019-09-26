class Api::V1::ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_via_token
  # around_action :set_time_zone

  private
  def authenticate_via_token
    if request.headers[:Authorization].blank?
      return render json: { success: false, msg: 'Authentication token not found.' }, status: 401
    end

    @token = request.headers[:Authorization]

    begin
      @decoded_token = JWT.decode @token, Settings.hmac_secret, true, { algorithm: 'HS256' }
      @user = User.find_by(id: @decoded_token.first["data"]["user"]["id"])

      if !@user
        return render json: {success: false, msg: 'Invalid token.'}, status: 401
      end

    rescue JWT::ExpiredSignature
      return render json: {success: false, msg: 'Token has expired.'}, status: 401

    rescue Exception => e
      return render json: {success: false, msg: e.message}, status: 401
    end
  end

    def set_time_zone
      if @user.nil?
        yield
      else
        Time.use_zone(@user.time_zone) do
          yield
        end
      end
    end
end
