class Api::V1::TeacherProfilesController < Api::V1::ApiController
    def update
        @profile = @user.profile
        @profile.update_attributes(profile_params)
    end

    private
        def profile_params
            params.fetch(:profile, {}).permit(:full_name, :organization, :phone)
        end
end
