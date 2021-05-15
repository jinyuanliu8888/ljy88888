class CreateSpeciesLocationTrails < ActiveRecord::Migration
  def change
    create_table :species_location_trails do |t|
      t.belongs_to :species_location
      t.belongs_to :trail
      t.timestamps null: false
    end
  end
end
