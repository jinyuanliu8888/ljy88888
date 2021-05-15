class AddImagesCreatorCopyright < ActiveRecord::Migration
  def change
    add_column :images, :creator, :string
    add_column :images, :copyright_holder, :string
  end
end
