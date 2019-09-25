user = teacher.user

json.profile_id     teacher.id
json.user_id        teacher.user.id
json.name           teacher.full_name
json.avatar         teacher.avatar
json.organization   teacher.organization
json.phone          teacher.phone
json.about          teacher.about
json.role           user.role
json.interests      user.interests.join(",")

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
