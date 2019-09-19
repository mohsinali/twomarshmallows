json.success true
json.msg 'Student profile created successfully.'

json.data do
  json.partial! 'student', student: @student.profile
end