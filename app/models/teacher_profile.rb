class TeacherProfile < ApplicationRecord
  
  ## Associations
  belongs_to :user
  has_one :picture, as: :imageable

  ## Scopes


  ## Class Methods

  ## Instance Methods
  
  ## Returns all students of a teacher's class
  def students
    StudentProfile.where(teacher_id: self.user_id)
  end
  
end
