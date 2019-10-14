class CreatePictures < ActiveRecord::Migration[5.2]
  def change
    create_table :pictures do |t|
      t.string  :avatar_hair
      t.string  :avatar_accessories
      t.string  :avatar_facial_hair
      t.string  :avatar_facial_hair_color
      t.string  :avatar_clothes
      t.string  :avatar_skin_color
      t.string  :name
      t.bigint  :imageable_id
      t.string  :imageable_type
      t.timestamps
    end
    add_index :pictures, [:imageable_type, :imageable_id]
  end
end
