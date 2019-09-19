class StudentsMailer < ApplicationMailer
  def new_account student, password
    @student, @password  = student, password
    @profile  = @student.profile

    mail(to: @student.email, subject: "TwoMarsmallow: Your account has been created.") 
  end
end
