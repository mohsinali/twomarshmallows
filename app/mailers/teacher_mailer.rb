class TeacherMailer < ApplicationMailer
  def account_activated teacher, password=""
    @teacher, @password  = teacher, password
    @profile  = @teacher.profile

    mail(to: @teacher.email, subject: "Welcome to the Two Marshmallows Community") 
  end
end
