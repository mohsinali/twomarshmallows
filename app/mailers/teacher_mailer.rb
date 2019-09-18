class TeacherMailer < ApplicationMailer
  def account_activated teacher, password
    @teacher, @password  = teacher, password
    @profile  = @teacher.profile

    mail(to: @teacher.email, subject: "TwoMarsmallow: Your account has been activated.") 
  end
end
