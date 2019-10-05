json.success true
json.msg 'Students Community.'

json.data do
  json.array! @students do |std|
      json.partial! 'api/v1/students/student', student: std
  end
end
