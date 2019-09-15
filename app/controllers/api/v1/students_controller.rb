class Api::V1::StudentsController < Api::V1::ApiController
  def create
    @student = StudentProfile.new(student_params)
    @student.teacher_id = @user.id
    @student.save!
  end

  private
    def student_params
      params.fetch(:student, {}).permit(:name, :grade, :school, :age)
    end
end
