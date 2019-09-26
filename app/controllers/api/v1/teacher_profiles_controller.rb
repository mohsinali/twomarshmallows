class Api::V1::TeacherProfilesController < Api::V1::ApiController

  def update
    @profile = @user.profile
    @profile.update_attributes(profile_params)
  end

  def my_community
    @community = User.with_any_role(:teacher, :student).reject{|u| u.is_active == false}.reverse
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

  private
    def profile_params
      params.fetch(:profile, {}).permit(:full_name, :organization, :phone, :avatar, :about)
    end
end
