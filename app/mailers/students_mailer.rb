class StudentsMailer < ApplicationMailer
  def new_account student, password
    @student, @password  = student, password
    @profile  = @student.profile

    mail(to: @student.email, subject: "TwoMarsmallow: Your account has been created.")
  end

  def account_activated student
    @student = student
    @profile  = @student.profile

    mail(to: @student.email, subject: "TwoMarsmallow: Your account has been activated.")
  end

  def account_deactivated student
    @student = student
    @profile  = @student.profile

    mail(to: @student.email, subject: "TwoMarsmallow: Your account has been deactivated.")
  end

end
