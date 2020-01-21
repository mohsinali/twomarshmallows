class ApplicationMailer < ActionMailer::Base
  default :from => "#{Rails.application.config.default_name}".concat(' <dan@twomarshmallows.ca>')
  layout 'mailer'
end
