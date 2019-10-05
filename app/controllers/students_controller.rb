class StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student, only: [:show]

  def index
    ## Paginate the end result
    apply_filters()
    ## Paginate the end result
    @students = Kaminari.paginate_array(@students).page(params[:page])
    @student  = @students.first
    # @total_count = @students.size
  end

  def show
  end

  private
    def set_student
      @student = User.find_by(id: params[:id])
    end

    def apply_filters
      @students = User.with_role(:student)

      # Filter For School
      if !params[:school].blank?
        @students = @students.select{ |student| student.profile.school== params[:school]}
      end

      ## Status filter
      unless params[:status].blank? or params[:status] == 'Any'
        params[:status] == "true" ? @students = @students.select{|student| student.is_active?} : @students = @students.select{|student| !student.is_active?}
      end

      ## Age filter
      unless params[:age].blank?
        @students = @students.select{ |student| student.profile.age == params[:age].to_i}
      end

      ## Grade filter
      unless params[:grade].blank?
        @students = @students.select{ |student| student.profile.grade == params[:grade].to_i}
      end

      ## Language Filter
      unless params[:lang].blank?
        lang = params[:lang]
        @students = @students.select{|student| student.languages.map{|l| l.language_code}.include?(lang)}
      end
      unless params[:lang_status].blank?
        status_check = (params[:lang_status].to_s.downcase == "true")
        @students = @students.select{|student| student.languages.select{ |l| l.is_native.eql?(status_check) && (!params[:lang].blank? ? l.language_code.eql?(params[:lang]) : true)}.any?}

      end
    end

end
