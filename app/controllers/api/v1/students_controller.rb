require "google/cloud/firestore"

class Api::V1::StudentsController < Api::V1::ApiController
  before_action :authenticate_via_token
  before_action :only_students, only: [:my_community]

  def create
    return render json: { success: false, msg: 'Email is required.' } if params[:student][:email].blank?
    begin
      password = Devise.friendly_token.first(6)
      @student = User.create!(email: params[:student][:email], password: password)
      @student.add_role(:student)

      @student.create_profile(student_params, {teacher_id: @user.id})

      # Adding user_status on firebase w.r.t user id
      firestore = Google::Cloud::Firestore.new credentials: ENV["FIREBASE_CREDENTIALS_PATH"]
      doc_ref = firestore.doc("user_status/#{@student.id}")
      doc_ref.set(is_active: true)

      ## Notify student about their login
      StudentsMailer.new_account(@student, password).deliver_now
    rescue Exception => e
      return render json: { success: false, msg: e.message }
    end
  end

  ## Students community
  def my_community
    # teacher_id = @user.student_profile.teacher_id
    @students = StudentProfile.all
    @students = @students.select{ |student| !student.about.nil?}
    @class_fellows = @user.profile.class_fellows
  end

  def update
    @profile = @user.profile
    @profile.update_attributes(student_params)
    Picture.find_or_initialize_by(imageable_id: @profile.id, imageable_type: "StudentProfile").update_attributes(avatar_params)
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

    def only_students
      return render json: { success: false, msg: 'Data only for students.' } unless @user.has_role?(:student)
    end

    def avatar_params
      params.fetch(:avatar, {}).permit(:avatar_hair, :avatar_accessories, :avatar_facial_hair, :avatar_facial_hair_color, :avatar_clothes, :avatar_skin_color)
    end
end
