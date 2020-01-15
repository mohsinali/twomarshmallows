class AddIndexInUserLanguages < ActiveRecord::Migration[5.2]
  def change
    remove_index :user_languages, [:user_id, :language_code]
    add_index :user_languages, [:user_id, :language_code, :is_native], :unique => true
  end
end
