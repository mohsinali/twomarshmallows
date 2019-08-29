class CreateTeacherProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :teacher_profiles do |t|
      t.string :full_name
      t.string :organization
      t.string :phone
      t.references :user

      t.timestamps
    end
  end
end
