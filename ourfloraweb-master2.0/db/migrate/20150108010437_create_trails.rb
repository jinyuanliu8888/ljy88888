class CreateTrails < ActiveRecord::Migration
  def change
    create_table :trails do |t|
      t.text :name
      t.timestamps null: false
    end
  end
end
