json.success true
json.msg 'Profile updated sucessfully.'
json.data do
  json.id           @profile.id
  json.name         @profile.name
  json.grade        @profile.grade
  json.school       @profile.school
  json.age          @profile.age
  json.about        @profile.about
  json.is_active    @profile.user.is_active

  json.avatar do
    unless @profile.picture.nil?      
      json.partial! 'api/v1/shared/avatar', picture: @profile.picture
    end
  end
end
