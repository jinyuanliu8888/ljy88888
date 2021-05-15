class AddSpeciesLocationInformation < ActiveRecord::Migration
  def change
    add_column :species_locations, :information, :text
  end
end
