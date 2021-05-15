class AddArborPlanIdToSpeciesLocations < ActiveRecord::Migration
  def change
    add_column :species_locations, :arborplan_id, :string
  end
end
