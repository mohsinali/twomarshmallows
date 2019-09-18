json.success true
json.msg 'Students'

json.data do
  json.array! @students do |student|
    json.partial! 'api/v1/students/student', student: student
  end
end