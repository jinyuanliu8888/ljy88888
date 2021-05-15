class AddSlugToSpecies < ActiveRecord::Migration
  def change
    add_column :species, :slug, :string
  end
end
