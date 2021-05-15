ActiveAdmin.register Image do
  permit_params :image, :creator, :copyright_holder

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.semantic_errors
    f.inputs "Upload Image" do
      f.input :image, :as => :file, :hint => f.template.image_tag(f.object.image.url(:medium))
      f.actions
    end
    f.inputs "Attribution" do
      f.input :creator
      f.input :copyright_holder
    end
  end

  show do |pic|
    attributes_table do
      row :image_file_name
      row :image_content_type
      row :image_file_size
      row :image_updated_at
      row :thumbnail do
        image_tag(pic.image.url(:thumb))
      end
      row :creator
      row :copyright_holder
      # Will display the image on show object page
    end
  end

    # This defines the column order for the index page which shows the list of all species
  index do
    selectable_column
    column :id
    column :thumbnail do |pic|
      image_tag(pic.image.url(:thumb))
    end
    column :image_file_name
    column :image_content_type
    column :image_file_size
    column :genusSpecies
    column :creator
    column :copyright_holder
    actions
  end

  # Define which filters (search criteria) should be available and in what order
  filter :species, as: :select, collection: Species.all.order('genusSpecies')
  filter :image_file_name
  filter :image_content_type
  filter :image_file_size
  filter :created_at
  filter :creator
  filter :copyright_holder
  filter :updated_at

end
