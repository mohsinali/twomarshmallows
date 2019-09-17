class AddColumnAvatarInStudentProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :student_profiles, :avatar, :string
  end
end
