class Page2Controller < ApplicationController
  before_action :authenticate_user!

  def index
    @title = 'Page 2'
  end
end
