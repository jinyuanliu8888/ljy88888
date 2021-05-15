class AddPhylogenyToFamilies < ActiveRecord::Migration
  def change
    add_column :families, :phylogeny, :string
  end
end
