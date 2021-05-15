class AddOrderToSpeciesLocationTrails < ActiveRecord::Migration
  def change
    add_column :species_location_trails, :order, :integer
  end
end
