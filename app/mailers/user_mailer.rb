class UserMailer < ApplicationMailer
  
  def invitation email, user, meeting
    @user     = user
    @meeting  = meeting
    mail(to: email, subject: "You are invited to meeting #{@meeting.title}")
  end

  def new_user_account user, password
    @user     = user
    @password = password
    mail(to: user.email, subject: "Your account has been created.")
  end
end
