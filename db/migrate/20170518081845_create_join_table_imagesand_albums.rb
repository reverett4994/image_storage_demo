class CreateJoinTableImagesandAlbums < ActiveRecord::Migration
  def change
    create_join_table :images, :albums do |t|
      # t.index [:image_id, :album_id]
      # t.index [:album_id, :image_id]
    end
  end
end
