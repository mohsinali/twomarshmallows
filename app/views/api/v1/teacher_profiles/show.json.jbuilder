json.success true
json.msg 'Profiles'

json.data do
  
  json.partial! 'teacher', teacher: @teacher.profile if @teacher
  json.partial! 'api/v1/students/student', student: @student if @student
end