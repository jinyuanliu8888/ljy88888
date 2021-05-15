ActiveAdmin.register Trail do
  permit_params :name, :slug, :information, trail_points_attributes: [:id, :lat, :lon, :order], species_location_trails_attributes: [:id, :species_location_id, :trail_id, :order]
  remove_filter :species_location_trails
  remove_filter :trail_points

  before_filter :destroy_trail_points, only: [:update]
  before_filter :destroy_species_location_trails, only: [:update]

  controller do
    def find_resource
      scoped_collection.where(slug: params[:id]).first!
    end

    def destroy_trail_points
      Trail.where(slug: params[:id]).first!.trail_points.destroy_all
    end

    def destroy_species_location_trails
      Trail.where(slug: params[:id]).first!.species_location_trails.destroy_all
    end
  end

  form do |f|
    f.actions # adds the 'Submit' and 'Cancel' buttons
    f.semantic_errors # shows errors on :base
    f.inputs 'Details' do
      f.inputs          # builds an input field for every attribute
    end
    combined = []
    trail.trail_points.each do |t|
      combined[t.order] = t
    end
    trail.species_location_trails.each do |t|
      combined[t.order] = t
    end
    render partial: "admin/trail_new.html.erb", locals: { form: f, combined: combined }
    f.actions # adds the 'Submit' and 'Cancel' buttons
  end

  show do |trail|
    attributes_table do
      row :name
      row :slug
      row :information
    end

    combined = []
    trail.trail_points.each do |t|
      combined[t.order] = t
    end
    trail.species_location_trails.each do |t|
      combined[t.order] = t
    end

    render partial: "admin/trail_new.html.erb", locals: { combined: combined }

    active_admin_comments_for(resource)
  end
end
