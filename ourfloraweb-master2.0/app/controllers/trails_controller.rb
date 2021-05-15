class TrailsController < ApplicationController
  before_action :set_trail, only: [:show, :edit, :update, :destroy]

  # GET /trails
  # GET /trails.json
  def index
    @trails = Trail.includes(:species).all
    respond_to do |format|
      format.html {
        not_found
      }
      format.xml { render :xml => @trails }
      format.json {
        render :json => @trails.to_json(include: [:species => {:only => :id}])
      }
    end
  end

  def show
    respond_to do |format|
      # If they're looking at the interface and they specify a trail, load the index anyway but highlight the selected trail
      format.html {
        @families = Family.includes(:species).order(:name).load
        @families = @families.to_json(include: [:species => {:only => :id}])

        # Render list of all trails and species and push to the view as JSON so that backbone can use it
        @species = Species.eager_load(:family, :species_locations, :images)

        @trails = Trail.includes(:species_locations).all
        @trails = @trails.to_json(include: [:species_locations => {:only => [:id, :lat, :lon]}])

        @page_title = @trail_selected.name

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
    def set_trail
      puts params[:id]
      @trail_selected = Trail.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trail_params
      params[:trail]
    end
end
