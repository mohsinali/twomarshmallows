class AddColumnIsApprovedInTeacherProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :teacher_profiles, :is_approved, :boolean, default: false
  end
end
