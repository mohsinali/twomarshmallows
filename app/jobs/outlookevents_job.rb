class OutlookeventsJob < ApplicationJob
  queue_as :default

  def perform user, meeting
    unless user.setting.outlook_token.blank?
      @outlook      = OutlookService.new()
      access_token  = @outlook.get_access_token(user.setting.outlook_token)
      event = @outlook.create_event(access_token, meeting)
    end
  end
end
