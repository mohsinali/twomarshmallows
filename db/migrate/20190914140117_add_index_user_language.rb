class AddIndexUserLanguage < ActiveRecord::Migration[5.2]
  def change
    add_index :user_languages, ["user_id", "language_code"], :unique => true
  end
end
