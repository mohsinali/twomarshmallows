class TeachersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_teacher, only: [:show]

  def index
    ## Paginate the end result
    apply_filters()
    ## Paginate the end result
    @teachers = Kaminari.paginate_array(@teachers).page(params[:page])
    @teacher  = @teachers.first
    # @total_count = @teachers.size
  end

  def show
  end

  private
    def set_teacher
      @teacher = User.find_by(id: params[:id])
    end

    def apply_filters
      @teachers = User.with_any_role(:teacher)

      # Filter For School
      if !params[:organization].blank?
        @teachers = @teachers.select{ |teacher| teacher.profile.organization == params[:organization]}
      end

      ## Status filter
      unless params[:status].blank? or params[:status] == 'Any'
        params[:status] == "true" ? @teachers = @teachers.select{|teacher| teacher.is_active?} : @teachers = @teachers.select{|teacher| !teacher.is_active?}
      end

      ## Language Filter
      unless params[:lang].blank?
        lang = params[:lang]
        @teachers = @teachers.select{|teacher| teacher.languages.map{|l| l.language_code}.include?(lang)}
      end

      unless params[:lang_status].blank?
        status = (params[:lang_status].to_s.downcase == "true")
        @teachers = @teachers.select{|teacher| teacher.languages.select{ |l| l.is_native.eql?(status) && (!params[:lang].blank? ? l.language_code.eql?(params[:lang]) : true)}.any?}
      end
    end

end
