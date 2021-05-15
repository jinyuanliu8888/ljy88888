# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

# Include rbenv for setting ruby version
require 'capistrano/rbenv'

# Use capistrano-passenger for interfacing with Phusion Passenger 
require 'capistrano/passenger'

# Use capistrano-bundler to install gems after deploy
require 'capistrano/bundler'

# Use capistrano rails assets to pre compile production assets to public
require 'capistrano/rails/assets'

# Use capistrano/sitemap_generator to generate a sitemap for google and bing after deploy
require 'capistrano/sitemap_generator'

# Use capistrano/rails/console to get access to the production rails console through cap
require 'capistrano/rails/console'

# Include tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#   https://github.com/capistrano/passenger
#
# require 'capistrano/rvm'
# require 'capistrano/rbenv'
# require 'capistrano/chruby'
# require 'capistrano/bundler'
# require 'capistrano/rails/assets'
# require 'capistrano/rails/migrations'
# require 'capistrano/passenger'

# Load custom tasks from `lib/capistrano/tasks' if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
Rake::Task[:production].invoke
