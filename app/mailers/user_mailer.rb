class UserMailer < ApplicationMailer  

  def new_signup user
    @user     = user

    mail(to: Settings.admin_email, subject: "New Signup")
  end
end
