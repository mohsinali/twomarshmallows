class StudentProfile < ApplicationRecord
  ## Associations
  belongs_to :user, optional: true
  belongs_to :teacher, class_name: "User", foreign_key: "teacher_id"
end
