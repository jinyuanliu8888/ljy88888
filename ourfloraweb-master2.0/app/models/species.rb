class Species < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  extend FriendlyId

  friendly_id :genusSpecies, use: :slugged

  after_save :expire_cache

  belongs_to :family
  has_many :species_locations

  has_many :images

  accepts_nested_attributes_for :family
  accepts_nested_attributes_for :species_locations, :allow_destroy => true
  accepts_nested_attributes_for :images, :allow_destroy => true

  # When we update or create a new species, expire the front end cache for the species objects
  def expire_cache
    logger.debug 'expiring species cache'
    Rails.cache.clear
  end

  def slug=(value)
    if value.present?
      write_attribute(:slug, value)
    end
  end

  def display_name
    genusSpecies
  end
end