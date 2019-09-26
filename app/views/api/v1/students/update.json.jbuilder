json.success true
json.msg 'Profile updated sucessfully.'
json.data do
  json.id           @profile.id
  json.name         @profile.name
  json.grade        @profile.grade
  json.school       @profile.school
  json.age          @profile.age
  json.avatar       @profile.avatar
  json.about        @profile.about
end
