json.cache! 'species_index_json' do
  json.array! @species do |species|
    json.id species.id
    json.genusSpecies species.genusSpecies
    json.commonName species.commonName
    json.indigenousName species.indigenousName
    json.authority species.authority
    json.distribution species.distribution
    json.information species.information
    json.description species.description
    json.created_at species.created_at
    json.updated_at species.updated_at
    json.slug species.slug
    json.family species.family
    json.images species.images do |image|
      json.image_url image.image.url(:original)
      json.image_dimensions image.image.image_size(:original)
      json.image_url_desktop image.image.url(:medium_desktop)
      json.image_url_mobile image.image.url(:medium_mobile)
      json.image_url_thumb_retina image.image.url(:thumb_retina)
      json.image_url_thumb image.image.url(:thumb)
    end
    json.species_locations species.species_locations
  end
end