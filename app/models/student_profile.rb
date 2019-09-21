class StudentProfile < ApplicationRecord
  ## Associations
  belongs_to :user
  belongs_to :teacher, class_name: "User", foreign_key: "teacher_id"

  def full_name
    name
  end
end
