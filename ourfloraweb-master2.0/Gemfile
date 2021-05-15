source 'https://rubygems.org'
source 'https://rails-assets.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# Use the json-schema gem for validating imported json
gem 'json-schema'

# Color output from puts for logging
gem 'colorize'

# Detect if the user is mobile, tablet or desktop
gem 'browser'

# Use friendly_id to generate slugs
gem 'friendly_id'

# sitemap_generator to generate bing, google, yahoo sitemaps
gem 'sitemap_generator'

# Figaro for environment variables
gem 'figaro'

# Whenever for crontab management
gem 'whenever', :require => false

# Redcarpet for markdown parsing
gem 'redcarpet'

group :development do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
  gem 'pry'

  # Capistrano for deployment to remote servers
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-passenger'
  gem 'capistrano-bundler'
  gem 'capistrano-rails-console'
end

group :deployment do
  # Mysql for database engine
  gem 'mysql2'
  # Therubyracer for javascript execution
  gem 'therubyracer'
end

# Use activeadmin for managing database
gem 'activeadmin', github: 'activeadmin'
gem 'inherited_resources', github: 'josevalim/inherited_resources', branch: 'rails-4-2'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
# use devise for user accounts
gem 'devise'

# Use paperclip for file uploads, with paperclip-meta for identifying image dimensions
gem 'paperclip'
gem 'paperclip-meta'

# Actionpack page caching for caching json
gem 'actionpack-action_caching'

# Front end gems below -----
# Jquery
gem 'rails-assets-jquery'
# Normalize css
gem 'rails-assets-normalize.css'
# Backbone.js for front end MVC framework
gem 'rails-assets-backbone'
# Fastclick.js to remove mobile input delay on clicking elements
gem 'rails-assets-fastclick'
# Use lunr for full text front end searching
gem 'rails-assets-lunr.js'
# Markdown js for markdown parsing on the front end
gem 'rails-assets-markdown'
# Share-button is a nice little library for adding multiple types of social sharing
gem 'rails-assets-share-button'
# Photoswipe for mobile friendly image gallery
gem 'rails-assets-photoswipe'