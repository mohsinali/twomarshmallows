json.successs true
json.msg 'User profile.'

json.data do
  if @person.has_role?(:student)
    json.partial! 'api/v1/students/student', student: @person.profile
  else
    json.partial! 'api/v1/teacher_profiles/teacher', teacher: @person.profile
  end

end
