class SettingsController < ApplicationController
  before_action :authenticate_user!

  def index
    # @token = GoogleToken.new(current_user)
    # access_token = @token.fresh_token

    # send_message( access_token, "mohsin@attribes.com", "email_subject", "email_body")
  end

  def update_user_field
    field = params[:field]
    value = params[:value]

    current_user.update_attribute(field.to_sym, value)

    respond_to do |format|
      format.json {render json: { success: true, time_zone: value }}
    end
  end


  def reset_google_token
    current_user.update_attribute(:google_access_token, nil)

    respond_to do |format|
      format.html {redirect_to settings_path, notice: 'Your Gmail account integration has been removed.'}
    end
  end

end
