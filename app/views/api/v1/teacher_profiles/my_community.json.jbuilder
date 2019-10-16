json.success true
json.msg 'All teachers and only your students.'

json.data do
  json.array! @community do |m|
    if m.profile.class.name == 'StudentProfile'
      json.partial! 'api/v1/students/student', student: m.profile, class_fellow_flag: true

    elsif m.profile.class.name == 'TeacherProfile'
      json.partial! 'api/v1/teacher_profiles/teacher', teacher: m.profile
    end

  end
end
