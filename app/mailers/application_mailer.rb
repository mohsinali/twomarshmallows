class ApplicationMailer < ActionMailer::Base
  default :from => '"AmeriCamp" <hello@americamp.com>'
  layout 'mailer'
end
