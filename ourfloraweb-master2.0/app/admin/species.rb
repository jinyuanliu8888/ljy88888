ActiveAdmin.register Species do
  permit_params :commonName, :authority, :distribution, :indigenousName, :information, :genusSpecies, :description, :family_id, :slug, species_locations_attributes: [:lat, :lon, :arborplan_id, :information, :removed, :id, :_destroy], images_attributes: [:image, :id, :creator, :copyright_holder, :_destroy]
  remove_filter :species_location_trails

  # Override find resource to get the select species by the friendly slug, rather than int id
  controller do
    def find_resource
      scoped_collection.where(slug: params[:id]).first!
    end
    def index
      params[:order] = "families.name_asc"
      super
    end
  end

  # Content for the edit page
  form :html => { :enctype => "multipart/form-data" } do |f|
    f.semantic_errors # shows errors on :base
    f.actions # adds the 'Submit' and 'Cancel' buttons

    f.inputs 'Details' do
      f.input :family
      f.input :genusSpecies
      f.input :commonName
      f.input :indigenousName
      f.input :authority
      f.input :distribution
      f.input :description
      f.input :information
      f.input :slug
    end

    f.inputs 'Locations' do
      f.has_many :species_locations, heading: nil, allow_destroy: true, allow_update: true, new_record: true do |a|
        a.input :lat
        a.input :lon
        a.input :arborplan_id, :label => 'Arborplan ID'
        a.input :information
        if a.object.id
          a.input :removed, :label => "Mark as removed"
        end
        if (a.object.removed)
          a.input :removal_date, as: :string
        end
      end
    end

    f.inputs 'images' do
      f.has_many :images, heading: nil, allow_destroy: true, new_record: true do |a|
        a.input :image, :as => :attachment,
                        :required => true,
                        :hint => 'Accepts JPG, GIF, PNG.',
                        :image => proc { |o| o.image.url(:thumb) }
        a.input :creator
        a.input :copyright_holder
      end
    end

    f.actions # adds the 'Submit' and 'Cancel' buttons
  end

  # Content for the individual species "view" page
  show do |species|
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)
    attributes_table do
      row :family do
        species.family.name
      end
      row :genusSpecies
      row :authority
      row :commonName
      row :indigenousName
      row :distribution
      row :description do
        markdown.render(species.description).html_safe
      end
      row :information do
        markdown.render(species.information).html_safe
      end
    end

    panel 'Locations' do
      table_for species.species_locations do
        column 'Location ID', :id
        column 'Arborplan ID', :arborplan_id
        column 'Latitude', :lat
        column 'Longitude', :lon
        column 'Information', :information
      end
    end

    panel 'Images' do
      species.images.each do |pic|
        span do
          image_tag(pic.image.url(:thumb))
        end
      end
    end

    active_admin_comments_for(resource)
  end

  scope :joined, :default => true do |species|
    species.includes [:family]
  end

  # This defines the column order for the index page which shows the list of all species
  index do
    selectable_column
    column "Family", :sortable => :'families.name' do |species|
      species.family and species.family.name or 'No Family'
    end
    column :genusSpecies
    column :authority
    column :commonName
    column :indigenousName
    column :distribution
    column :description
    column :information
    column :created_at
    column :updated_at
    column :slug
    actions
  end

  # Define which filters (search criteria) should be available and in what order
  filter :family, as: :select, collection: proc { Family.all.order('name') }
  filter :genusSpecies
  filter :authority
  filter :commonName
  filter :indigenousName
  filter :distribution
  filter :description
  filter :information
  filter :created_at
  filter :updated_at
  filter :slug

end
