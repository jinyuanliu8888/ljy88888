class CreateTrailPoints < ActiveRecord::Migration
  def change
    create_table :trail_points do |t|
      t.belongs_to :trail
      t.integer :order
      t.decimal :lat, {:precision=>10, :scale=>6}
      t.decimal :lon, {:precision=>10, :scale=>6}
      t.timestamps null: false
    end
  end
end
