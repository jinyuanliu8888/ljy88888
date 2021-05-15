class SpeciesLocation < ActiveRecord::Base
  belongs_to :species

  has_many :species_location_trails
  has_many :trails, through: :species_location_trails, :class_name => 'Trail'
  accepts_nested_attributes_for :species_location_trails

  after_save do
    if self.removed and !self.removal_date then
      self.removal_date = DateTime.now
      self.save()
    elsif !self.removed and self.removal_date then
      self.removal_date = null
      self.save()
    end
    Rails.cache.clear
  end
end
