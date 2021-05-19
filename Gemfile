source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.2.3'
#ruby-gemset=jpegger_web

# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 4.3'

gem 'bootsnap', require: false

# Use SCSS for stylesheets
#gem 'sass-rails', '~> 5.0'
# Bootstrap 4 Ruby Gem for Rails / Sprockets and Compass. 
#gem 'bootstrap'
# Font-Awesome Sass gem for use in Ruby/Rails projects
#gem 'font-awesome-sass'

gem 'sassc'
gem 'bootstrap-sass'
gem 'font-awesome-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
#gem 'therubyracer', platforms: :ruby
gem 'mini_racer'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Flexible authentication solution for Rails with Warden. 
gem 'devise'

# Use haml views
gem 'haml'
gem 'haml-rails'

gem 'jquery-rails'
gem 'popper_js', '~> 1.12.9'

# Set environment variables within application.yml
gem "figaro"

# Do some browser detection with Ruby. Includes ActionController integration.
gem 'browser'

gem 'simple_form'

# SOAP calls to web services
gem 'savon'

# Pagination: https://github.com/amatsuda/kaminari
gem 'kaminari'

# Authorization
gem 'cancancan'

# https://github.com/Nerian/bootstrap-datepicker-rails
gem 'bootstrap-datepicker-rails'

# Provide a clear syntax for writing and deploying cron jobs.
gem 'whenever', :require => false

# Exception notifications
gem 'exception_notification'

# File uploads
gem 'carrierwave'
# mini replacement for RMagick http://mini_magick.rubyforge.org/
gem "mini_magick"

# Dynamically add and remove nested has_many association fields in a Ruby on Rails form
gem 'nested_form_fields'

# Background jobs
gem 'sidekiq'
# For sidekiq web UI
gem 'sinatra', github: 'sinatra/sinatra', require: false
gem 'rack-protection'

# Integrate Select2 javascript library with Rails asset pipeline https://github.com/argerim/select2-rails
gem "select2-rails"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]