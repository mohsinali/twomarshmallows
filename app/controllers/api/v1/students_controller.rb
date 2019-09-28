class Api::V1::StudentsController < Api::V1::ApiController
  before_action :authenticate_via_token

  def create
    return render json: { success: false, msg: 'Email is required.' } if params[:student][:email].blank?
    begin
      password = Devise.friendly_token.first(6)
      @student = User.create!(email: params[:student][:email], password: password)
      @student.add_role(:student)

      @student.create_profile(student_params, {teacher_id: @user.id})

      ## Notify student about their login
      StudentsMailer.new_account(@student, password).deliver_now
    rescue Exception => e
      return render json: { success: false, msg: e.message }
    end
  end

  def my_community
    teacher_id = @user.student_profile.teacher_id
    @students = StudentProfile.where(teacher_id: teacher_id)
    return render json: {success: true, msg: "Students Community.", data: @students }
  end

  def update
    @user.student_profile.update_attributes(student_params)
  end

  def interests
    if request.get?
      @interests = @user.interests
      msg = 'User interests'
    end

    if request.post?
      @user.interest_list = params[:interests]
      @user.save

      @interests = @user.interests
      msg = 'Interests saved.'
    end

    return render json: {success: true, msg: msg, data: {interests: @interests.join(",")} }
  end

  def languages
    if request.post?
      @user.languages.destroy_all
      params[:languages].each do |lang|
        UserLanguage.create!(user_id: @user.id, language_code: lang[:language_code], is_native: lang[:is_native]) rescue ActiveRecord::RecordNotUnique
      end
    end

    @languages = @user.languages.reload
  end

  private
    def student_params
      params.fetch(:student, {}).permit(:name, :grade, :school, :age, :avatar, :about)
    end
end
