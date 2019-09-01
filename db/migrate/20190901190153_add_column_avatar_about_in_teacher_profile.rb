class AddColumnAvatarAboutInTeacherProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :teacher_profiles, :avatar, :string
    add_column :teacher_profiles, :about, :text
  end
end
