json.success true
json.msg 'Profile updated sucessfully.'
json.data do
  json.id           @user.profile.id
  json.name         @user.profile.name
  json.grade        @user.profile.grade
  json.school       @user.profile.school
  json.age          @user.profile.age
  json.avatar       @user.profile.avatar
  json.about        @user.profile.about
  json.is_active    @user.is_active
end
