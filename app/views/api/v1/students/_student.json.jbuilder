user = User.find(student.user.id)

json.profile_id   student.id
json.user_id      user.id
json.name         student.name
json.grade        student.grade
json.school       student.school
json.age          student.age
json.about        student.about
json.role         user.role
json.is_active    user.is_active
json.interests    user.interests.join(",")
json.class_fellow @class_fellows ? class_fellow_flag : false


json.avatar do
  json.partial! 'api/v1/shared/avatar', picture: student.picture
end

json.languages do
  json.native do
    json.array! user.languages do |lng|
      json.partial! 'api/v1/languages/language', lng: lng if lng.is_native == true
    end
  end

  json.speaks do
    json.array! user.languages do |lng|
      json.partial! 'api/v1/languages/language', lng: lng if lng.is_native == false
    end
  end
end
