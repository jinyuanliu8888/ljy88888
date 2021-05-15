class SpeciesLocationTrail < ActiveRecord::Base
  belongs_to :species_location
  belongs_to :trail
end
