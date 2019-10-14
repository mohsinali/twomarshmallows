json.success true
json.msg 'Students Community.'

json.data do  
  json.array! @students do |std|
    flag = @class_fellows.include?(std)
    json.partial! 'api/v1/students/student', student: std, class_fellow_flag: flag
  end
end
