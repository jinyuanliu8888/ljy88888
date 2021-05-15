class AddImageMetaToImages < ActiveRecord::Migration
  def change
    add_column :images, :image_meta, :text
  end
end
