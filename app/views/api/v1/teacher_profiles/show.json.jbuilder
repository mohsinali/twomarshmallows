json.success true
json.msg 'Profiles'

json.data do
  json.partial! 'teacher', teacher: @teacher.profile
end