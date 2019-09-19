class Api::V1::StudentsController < Api::V1::ApiController
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

  private
    def student_params
      params.fetch(:student, {}).permit(:name, :grade, :school, :age)
    end
end
