class CreateStudentProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :student_profiles do |t|
      t.string :name
      t.integer :grade
      t.string :school
      t.integer :age
      t.integer :teacher_id
      t.integer :user_id

      t.timestamps
    end
  end
end
