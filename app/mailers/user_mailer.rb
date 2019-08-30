class UserMailer < ApplicationMailer  

  def new_signup user
    @user             = user
    @teacher_profile  = user.teacher_profile

    mail(to: Settings.admin_email, subject: "A Teacher Showed Up")
  end
  
  def new_teacher_s_notify teacher
    @teacher  = teacher
    @profile  = teacher.teacher_profile

    mail(to: @teacher.email, subject: "TwoMarsmallow: Just A Little Wait") 
  end
end
