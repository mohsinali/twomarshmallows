user = User.find(student.user.id)

json.profile_id   student.id
json.user_id      student.user.id
json.name         student.name
json.avatar       student.avatar
json.grade        student.grade
json.school       student.school
json.age          student.age
json.role         user.role
json.interests    user.interests.join(",")

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
