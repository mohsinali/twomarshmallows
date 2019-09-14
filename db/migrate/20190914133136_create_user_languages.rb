class CreateUserLanguages < ActiveRecord::Migration[5.2]
  def change
    create_table :user_languages do |t|
      t.integer :user_id
      t.string :language_code
      t.boolean :is_native
      
      t.timestamps
    end
  end
end
