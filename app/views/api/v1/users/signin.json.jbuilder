json.successs true
json.msg 'User assigned authentication token.'

json.token      @user.jwt_token
json.id         @user.id
json.name       @user.profile.full_name
json.about      @user.profile.about
json.role       @user.role
json.is_active  @user.is_active
json.has_avatar @user.has_avatar?

json.avatar do
  json.partial! 'api/v1/shared/avatar', picture: @user.profile.picture
end
