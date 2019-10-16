json.success true
json.msg 'Suspended students'

json.data do
  json.array! @students do |student|
    json.partial! 'api/v1/students/student', student: student, class_fellow_flag: true
  end
end