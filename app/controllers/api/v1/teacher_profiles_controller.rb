class Api::V1::TeacherProfilesController < Api::V1::ApiController
  
  def update
    @profile = @user.profile
    @profile.update_attributes(profile_params)
  end

  def interests
    if request.get?
      @interests = @user.interests
      msg = 'User interests'
    end

    if request.post?
      @user.interest_list.add(params[:interests], parse: true)
      @user.save

      @interests = @user.interests
      msg = 'Interests saved.'
    end

    return render json: {success: true, msg: msg, data: {interests: @interests.join(",")} }
  end

  private
    def profile_params
      params.fetch(:profile, {}).permit(:full_name, :organization, :phone)
    end
end
