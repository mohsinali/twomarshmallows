class UserMailer < ApplicationMailer

  def new_signup user
    @user             = user
    @teacher_profile  = @user.profile

    mail(to: Settings.admin_email, subject: "A Teacher Showed Up")
  end

  def new_teacher_notify teacher
    @teacher  = teacher
    @profile  = @teacher.profile

    mail(to: @teacher.email, subject: "TwoMarsmallow: Just A Little Wait")
  end

  def forgot_password(user, raw, url)
    @user = user
    @token = raw
    @url = url

    mail(to: @user.email, subject: "Reset password instructions has been sent to your mail.")
  end
end
