class ApplicationMailer < ActionMailer::Base
  default :from => '"TwoMarshmallow" <hello@twomarshmallows.com>'
  layout 'mailer'
end
