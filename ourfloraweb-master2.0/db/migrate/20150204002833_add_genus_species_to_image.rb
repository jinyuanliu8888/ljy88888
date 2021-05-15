class AddGenusSpeciesToImage < ActiveRecord::Migration
  def change
    add_column :images, :genusSpecies, :string
    Image.all.each do |image|
      image.genusSpecies = image.species.genusSpecies
      image.save!
    end
  end
end
