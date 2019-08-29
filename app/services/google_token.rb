class GoogleToken
  def initialize(user)
    @user = user    
  end

  def to_params
    {
      'refresh_token' => @user.google_refresh_token,
      'client_id'     => ENV['GOOGLE_CLIENT_ID'],
      'client_secret' => ENV['GOOGLE_CLIENT_SECRET'],
      'grant_type'    => 'refresh_token'
    }
  end

  def request_token_from_google
    url = URI("https://accounts.google.com/o/oauth2/token")
    Net::HTTP.post_form(url, self.to_params)
  end

  def refresh!
    response  = request_token_from_google()
    data      = JSON.parse(response.body)
    
    @user.update_attributes(
      google_access_token: data['access_token'],
      google_token_expires_at: Time.now + (data['expires_in'].to_i).seconds
    )
  end

  def expired?
    @user.google_token_expires_at < Time.now
  end

  def fresh_token
    refresh! if expired?
    @user.google_access_token
  end  

end

# https://www.twilio.com/blog/2014/12/sms-alerts-for-urgent-emails-with-twilio-and-the-gmail-api.html