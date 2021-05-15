class CreatePageContent < ActiveRecord::Migration
  def change
    create_table :page_contents do |t|
      t.text :about_page_content
      t.timestamps null: false
    end

    # Create a single row for the about page content
    PageContent.create!(:about_page_content => 'Test Content')
  end
end
