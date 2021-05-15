class SpeciesTrail < ActiveRecord::Base
  belongs_to :species
  belongs_to :trail
end
