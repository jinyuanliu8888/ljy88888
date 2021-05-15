class CreateSpeciesTrails < ActiveRecord::Migration
  def change
    create_table :species_trails, id: false do |t|
      t.belongs_to :species, index: true
      t.belongs_to :trail, index: true
    end
  end
end
