
source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~>4.1'

# Use oracle as the database for Active Record
gem 'ruby-oci8'

# Oracle enhanced ActiveRecord adapter provides Oracle database access from Ruby on Rails applications
gem "activerecord-oracle_enhanced-adapter", "~> 1.5"

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  #noinspection RubyArgCount
  gem 'sdoc', require: false
end

# dry_crud generates simple and extendable controllers, views and helpers
# that support you to DRY up the CRUD code in your Rails projects.
# https://github.com/codez/dry_crud
gem 'dry_crud'

# For adding pagination to lists
# https://github.com/amatsuda/kaminari
gem 'kaminari'

# https://github.com/composite-primary-keys/composite_primary_keys
gem 'composite_primary_keys', '~> 7.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7' # formerly bcrypt-ruby

# Use unicorn as the app server
# gem 'unicorn'

# Do not place the capistrano-related gems in the default or Rails.env bundle group
# Otherwise the config/application.rb's Bundle.require command will try to load them
# leading to failure because these gem's rake task files use capistrano DSL.
group :deployment do
  # Use Capistrano for deployment
  gem 'capistrano', '~> 3.1'
  gem 'capistrano-bundler', '~> 1.1'
  gem 'capistrano-rvm', '~> 0.1'
  gem 'lyberteam-capistrano-devel', '~> 3.0'
end

# Use debugger
# gem 'debugger', group: [:development, :test]
