class AddPrimaryKeyToSpeciesTrails < ActiveRecord::Migration
  def change
    add_column :species_trails, :id, :primary_key
  end
end
