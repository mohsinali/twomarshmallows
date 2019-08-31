class TeachersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_teacher, only: [:show]

  def index
    @teachers = User.with_any_role(:teacher)
    ## Paginate the end result
    @teachers = Kaminari.paginate_array(@teachers).page(params[:page])
  end

  def show
  end

  private
    def set_teacher
      @teacher = User.find_by(id: params[:id])
    end

end
