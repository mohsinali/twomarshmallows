require 'signet/oauth_2/client'
require 'google/apis/gmail_v1'

module GmailApi
  extend ActiveSupport::Concern

  def send_message access_token, email, email_subject, email_body
    begin      
      client = Signet::OAuth2::Client.new(access_token: access_token)      
      client.expires_in = Time.now + 1_000_000
  
      service = Google::Apis::GmailV1::GmailService.new
      service.authorization = client
  
      mail = m = Mail.new(
        to: email,
        subject: email_subject
      )
      
      html_part = Mail::Part.new do
        content_type 'text/html; charset=UTF-8'
        body email_body
      end
      mail.html_part = html_part
      message = Google::Apis::GmailV1::Message.new(raw: mail.to_s)
      
      data = service.send_user_message('me',message)
    rescue => e
      puts "============= Exception - GoogleToken Module - send_message ============="
      puts e.message
    end
  end

end