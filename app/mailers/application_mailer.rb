class ApplicationMailer < ActionMailer::Base
  default :from => '"TwoMarshmallows" <hello@twomarshmallows.com>'
  layout 'mailer'
end
