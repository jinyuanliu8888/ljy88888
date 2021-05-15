class CreateSpeciesAndImages < ActiveRecord::Migration
  def change
    create_table :species do |t|
      t.string :genusSpecies
      t.string :commonName
      t.string :indigenousName
      t.string :authority
      t.text :distribution
      t.text :information
      t.text :description
      t.timestamps null: false

      t.references :family
    end

    create_table :images do |t|
      t.timestamps null: false
      t.attachment :image

      t.belongs_to :species
    end
  end
end
