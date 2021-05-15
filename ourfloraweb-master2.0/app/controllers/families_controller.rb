class FamiliesController < ApplicationController
  before_action :set_family, only: [:show, :edit, :update, :destroy]

  # GET /families
  # GET /families.json
  def index
    @families = Family.includes(:species).order(:name).all
    respond_to do |format|
      format.html {
        not_found
      }
      format.xml { render :xml => @families }
      format.json {
        render :json => @families.to_json(include: [:species => {:only => :id}])
      }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_family
      @family = Family.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def family_params
      params[:family]
    end
end
