class CreateSetting < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.text :about_page_content
      # t.decimal  :lat
      # t.decimal  :lon
      t.decimal :lat, {:precision=>10, :scale=>6}
      t.decimal :lon, {:precision=>10, :scale=>6}
    end

    # Create a single row for the about page content
    # Setting.create!(:about_page_content => 'Test Content')
    Setting.create!(:about_page_content => 'test content', :lat => 'lat', :lon => 'lon')
  end
end 
