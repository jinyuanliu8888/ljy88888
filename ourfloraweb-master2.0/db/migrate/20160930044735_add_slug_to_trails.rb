class AddSlugToTrails < ActiveRecord::Migration
  def change
    add_column :trails, :slug, :string
  end
end
