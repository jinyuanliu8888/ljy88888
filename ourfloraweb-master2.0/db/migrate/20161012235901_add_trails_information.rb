class AddTrailsInformation < ActiveRecord::Migration
  def change
    add_column :trails, :information, :text
  end
end
