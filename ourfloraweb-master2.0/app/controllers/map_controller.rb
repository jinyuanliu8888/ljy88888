class MapController < ApplicationController
  def index
    # Render list of all species, trails and families and push to the view as JSON so that backbone can use it
    @species = Species.eager_load(:family, :species_locations, :images).where("species_locations.removed = false")
    @species_location_count = SpeciesLocation.count

    @families = Family.includes(:species).order(:name).load
    @families_count = Family.count
    @families = @families.to_json(include: [:species => {:only => :id}])

    @trails = Trail.includes(:species_location_trails).includes(:trail_points).all
    @trails = @trails.to_json(include: [:species_location_trails, :trail_points])

    # Initialise a markdown parser that we can use in the view to well, parse markdown
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)
    # Grab the about page content to render
    @page_content = PageContent.first
    @setting = Setting.first
  end
end
