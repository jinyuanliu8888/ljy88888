class SpeciesController < ApplicationController
  before_action :set_species, only: [:show]

  # GET /species
  # GET /species.json
  def index
    @species = Species.eager_load(:family, :species_locations, :images).order('families.name')
    respond_to do |format|
      format.html {
        not_found
      }
      format.xml { render :xml => @species }
      format.json {
         render :template => 'species/index.json'
      }
    end
  end

  def show
    respond_to do |format|
      # If they're looking at the interface and they specify a species, load the index anyway but highlight the selected species
      format.html {
        @families = Family.includes(:species).order(:name).load
        @families = @families.to_json(include: [:species => {:only => :id}])
        
        # Render list of all trails and species and push to the view as JSON so that backbone can use it
        @species = Species.eager_load(:family, :species_locations, :images).where("species_locations.removed = false")

        @trails = Trail.includes(:species_locations).all
        @trails = @trails.to_json(include: [:species_locations => {:only => [:id, :lat, :lon]}])

        @page_title = @species_selected.genusSpecies

        # Initialise a markdown parser that we can use in the view to well, parse markdown
        @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)
        # Grab the about page content to render
        @page_content = PageContent.first
        @setting = Setting.first
        render 'map/index'
      }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_species
      @species_selected = Species.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def species_params
      params(:species).permit(:species_locations_attributes => [:lat, :lon])
    end
end
