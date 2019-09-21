class AddColumnAboutInStudentProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :student_profiles, :about, :text
  end
end
