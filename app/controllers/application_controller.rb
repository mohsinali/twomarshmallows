class ApplicationController < ActionController::Base
  around_action :set_time_zone

  # Default layout
  layout 'main/layout-2'

  private
    def set_time_zone
      if current_user.nil?
        yield
      else
        Time.use_zone(current_user.time_zone) do
          yield
        end
      end
    end
    
end
