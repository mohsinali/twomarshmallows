class Api::V1::TeacherProfilesController < Api::V1::ApiController
  before_action :only_teachers, only: [:update, :my_community]

  def show
    if @user.id == params[:id].to_i
      @teacher = @user
    else
      @student = @user.students.where(user_id: params[:id].to_i)
      return render json: {success: false, msg: 'Invalid user id.'} unless @student.any?
      @student = @student.last
    end
  end

  def update
    @profile = @user.profile
    @profile.update_attributes(profile_params)
    Picture.find_or_initialize_by(imageable_id: @profile.id, imageable_type: "TeacherProfile").update_attributes(avatar_params)
  end

  def my_community
    @community = User.with_role(:teacher).reject{|u| u.is_active == false}.reverse
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

  def toggle_activate_student
    student_id = params[:student_id]
    @student_profile = StudentProfile.find_by(user_id: student_id, teacher_id: @user.id)

    if @student_profile
      user = @student_profile.user
      user.is_active ^= true
      user.save

      status = user.is_active ? 'activated' : 'deactivated'
      return render json: { success: true, msg: "Student account has been #{status}." }
    else
      return render json: { success: false, msg: 'Invalid student id.' }
    end
  end

  def students
    @students = @user.students
  end

  def suspended_students    
    @students = User.inactive.with_role(:student).includes(:student_profile).map{ |u| u.profile }
  end

  def unsuspended_students    
    @students = User.active.with_role(:student).includes(:student_profile).map{ |u| u.profile }
  end

  private
    def profile_params
      params.fetch(:profile, {}).permit(:full_name, :organization, :phone, :avatar, :about)
    end

    def avatar_params
      params.fetch(:avatar, {}).permit(:avatar_hair, :avatar_accessories, :avatar_facial_hair, :avatar_facial_hair_color, :avatar_clothes, :avatar_skin_color)
    end

    def only_teachers
      return render json: { success: false, msg: 'Teachers only.' } unless @user.has_role?(:teacher)
    end
end
