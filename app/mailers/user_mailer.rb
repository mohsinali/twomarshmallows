class UserMailer < ApplicationMailer  

  def new_signup user
    @user             = user
    @teacher_profile  = user.teacher_profile

    mail(to: Settings.admin_email, subject: "A Teacher Showed Up")
  end
end
