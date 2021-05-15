class AddSpeciesLocationsRemoved < ActiveRecord::Migration
  def change
    add_column :species_locations, :removed, :boolean, default: false
    add_column :species_locations, :removal_date, :datetime
  end
end
