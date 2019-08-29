module Emails
  extend ActiveSupport::Concern

  def send_email data
    if current_user.gmail_authenticated?
      @token = GoogleToken.new(current_user)
      access_token = @token.fresh_token
      
      send_message( access_token, data[:to], data[:subject], data[:body])
    else
      ContactsMailer.send_email(data).deliver_now
    end
    
    ## Log email message
    @email_message = EmailMessage.create(to: @contact.id, from: current_user.id, subject: data[:subject], body: data[:body])
    @contact.favorite(@email_message, scopes: [:activity])
  end
end