json.success true
json.msg 'Students'

json.data do
  json.array! @students do |student|
    flag = @class_fellows.include?(std)
    json.partial! 'api/v1/students/student', student: student, class_fellow_flag: flag
  end
end